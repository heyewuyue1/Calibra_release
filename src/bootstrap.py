import argparse
from collections import defaultdict

import torch
from torch import optim
from torch.utils.tensorboard.writer import SummaryWriter

from config import (
    DEFAULT_BENCHMARK,
    EnvironmentConfig,
    TrainConfig,
    ensure_dir,
    ensure_parent_dir,
    get_run_artifacts,
    update_manifest,
)
from models.TreeLRUNet import TreeLRUNet
from models.encoder import UnifiedFeatureEncoder
from preprocessor.sparkplanpreprocessor import SparkPlanPreprocessor
from request_models import PlanInfo
from utils.logger import setup_custom_logger
from utils.util import flatten_tree_batch_for_tree_lru


logger = setup_custom_logger("TRAIN")
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", default=DEFAULT_BENCHMARK)
    parser.add_argument("--run-id")
    parser.add_argument("--data-path")
    parser.add_argument("--base-model-path")
    parser.add_argument("--model-save-path")
    parser.add_argument("--metrics-path")
    parser.add_argument("--tensorboard-dir")
    parser.add_argument("--epochs", type=int)
    parser.add_argument("--target-train-match-rate", type=float)
    return parser.parse_args()


def teacher_choices_from_record(record):
    candidate_count = len(record.get("candidates", []))
    raw_choices = record.get("teacher_choices")
    if raw_choices is None and record.get("teacher_choice") is not None:
        raw_choices = [record["teacher_choice"]]
    if raw_choices is None:
        return []
    if isinstance(raw_choices, int):
        raw_choices = [raw_choices]

    choices = []
    for choice in raw_choices:
        if not isinstance(choice, int) or not 0 <= choice < candidate_count:
            return []
        if choice not in choices:
            choices.append(choice)
    return choices


def has_valid_teacher_label(record):
    return bool(teacher_choices_from_record(record))


def load_labeled_slates(path):
    records = torch.load(path)
    labeled_records = [record for record in records if has_valid_teacher_label(record)]
    return records, labeled_records


def featurize_labeled_slates(slates, encoder, preprocessor=None):
    preprocessor = preprocessor or SparkPlanPreprocessor()
    encoded = []
    for slate in slates:
        plans = []
        for candidate in slate["candidates"]:
            plan_info = candidate if isinstance(candidate, PlanInfo) else PlanInfo(**candidate)
            plans.append(encoder.featurize(preprocessor.plan2tree(plan_info)))
        encoded.append(
            {
                "teacher_choices": teacher_choices_from_record(slate),
                "plans": plans,
                "query_id": slate.get("query_id"),
            }
        )
    return encoded


def tree_node_count(tree):
    count = 1
    if len(tree) > 1:
        count += tree_node_count(tree[1])
    if len(tree) > 2:
        count += tree_node_count(tree[2])
    return count


def prepare_grouped_slate_batches(slates):
    grouped = defaultdict(lambda: {"plans": [], "targets": []})
    for slate in slates:
        candidate_count = len(slate["plans"])
        slate_max_nodes = max(tree_node_count(plan) for plan in slate["plans"])
        grouped[(candidate_count, slate_max_nodes)]["plans"].extend(slate["plans"])
        target = [0.0] * candidate_count
        positive_weight = 1.0 / len(slate["teacher_choices"])
        for choice in slate["teacher_choices"]:
            target[choice] = positive_weight
        grouped[(candidate_count, slate_max_nodes)]["targets"].append(target)

    prepared = []
    for candidate_count, slate_max_nodes in sorted(grouped):
        bucket = grouped[(candidate_count, slate_max_nodes)]
        prepared.append(
            {
                "candidate_count": candidate_count,
                "slate_max_nodes": slate_max_nodes,
                "slate_count": len(bucket["targets"]),
                "flattened_batch": flatten_tree_batch_for_tree_lru(bucket["plans"]),
                "targets": torch.tensor(bucket["targets"], dtype=torch.float32, device=device),
            }
        )
    return prepared


def _slate_costs_and_logits(model, batch):
    costs = model(batch["flattened_batch"]).squeeze(1)
    costs = costs.reshape(batch["slate_count"], batch["candidate_count"])
    return costs, -costs


def _add_loss(total_loss, bucket_loss):
    return bucket_loss if total_loss is None else total_loss + bucket_loss


def _grouped_cross_entropy_loss(model, grouped_batches):
    total_loss = None
    total_slates = 0

    for batch in grouped_batches:
        _, logits = _slate_costs_and_logits(model, batch)
        log_probs = torch.log_softmax(logits, dim=1)
        bucket_loss = -(batch["targets"] * log_probs).sum()
        total_loss = _add_loss(total_loss, bucket_loss)
        total_slates += batch["slate_count"]

    return total_loss / total_slates


def evaluate_grouped_batches(model, grouped_batches):
    model.eval()
    total_loss = None
    total_slates = 0
    match_count = 0

    with torch.no_grad():
        for batch in grouped_batches:
            costs, logits = _slate_costs_and_logits(model, batch)
            log_probs = torch.log_softmax(logits, dim=1)
            bucket_loss = -(batch["targets"] * log_probs).sum()
            total_loss = _add_loss(total_loss, bucket_loss)
            total_slates += batch["slate_count"]
            predicted_choices = torch.argmin(costs, dim=1)
            selected_target = batch["targets"].gather(
                1,
                predicted_choices.view(-1, 1),
            ).squeeze(1)
            match_count += int((selected_target > 0).sum().item())

    average_loss = float((total_loss / total_slates).item())
    match_rate = match_count / total_slates if total_slates else 0.0
    return average_loss, match_count, match_rate


def run_bootstrap_epoch(model, grouped_batches, optimizer):
    model.train()
    loss = _grouped_cross_entropy_loss(model, grouped_batches)
    optimizer.zero_grad(set_to_none=True)
    loss.backward()
    optimizer.step()
    return float(loss.item())


def train_bootstrap_model(
    model,
    grouped_batches,
    optimizer,
    tensorboard_dir,
    epochs,
    target_train_match_rate=1-1e-6,
):
    writer = SummaryWriter(log_dir=tensorboard_dir)
    best_train_loss = float("inf")
    best_train_match_count = -1
    best_train_match_rate = -1.0
    best_state = {k: v.detach().cpu().clone() for k, v in model.state_dict().items()}
    epoch_rows = []
    stopped_early = False

    try:
        for epoch in range(epochs):
            run_bootstrap_epoch(model, grouped_batches, optimizer)
            train_loss, train_match_count, train_match_rate = evaluate_grouped_batches(
                model, grouped_batches
            )
            writer.add_scalar("Loss/Train(CrossEntropy)", train_loss, epoch + 1)
            writer.add_scalar("Accuracy/TrainTeacherMatch", train_match_rate, epoch + 1)
            logger.info(
                "Epoch %d/%d train_ce=%.6f train_match=%d/%d (%.4f)",
                epoch + 1,
                epochs,
                train_loss,
                train_match_count,
                sum(batch["slate_count"] for batch in grouped_batches),
                train_match_rate,
            )
            epoch_rows.append((epoch + 1, train_loss, train_match_rate))
            if (
                train_match_count > best_train_match_count
                or (
                    train_match_count == best_train_match_count
                    and train_loss < best_train_loss
                )
            ):
                best_train_loss = train_loss
                best_train_match_count = train_match_count
                best_train_match_rate = train_match_rate
                best_state = {
                    k: v.detach().cpu().clone() for k, v in model.state_dict().items()
                }
            if (
                target_train_match_rate is not None
                and train_match_rate >= target_train_match_rate
            ):
                stopped_early = True
                logger.info(
                    "Reached target train match rate %.4f at epoch %d",
                    target_train_match_rate,
                    epoch + 1,
                )
                break
    finally:
        writer.close()

    return (
        epoch_rows,
        best_train_loss,
        best_train_match_count,
        best_train_match_rate,
        best_state,
        stopped_early,
    )


def save_bootstrap_state_dict(model, save_path):
    ensure_parent_dir(save_path)
    torch.save(model.state_dict(), save_path)


if __name__ == "__main__":
    args = parse_args()
    artifacts = get_run_artifacts(benchmark=args.benchmark, run_id=args.run_id)
    TrainConfig.current_time = artifacts.run_id
    EnvironmentConfig.configure_for_benchmark(args.benchmark)

    data_path = args.data_path or artifacts.bootstrap_data_path
    model_save_path = args.model_save_path or artifacts.bootstrap_model_path
    metrics_path = args.metrics_path or artifacts.bootstrap_metrics_path
    tensorboard_dir = args.tensorboard_dir or artifacts.bootstrap_tensorboard_dir
    base_model_path = args.base_model_path
    epochs = args.epochs or TrainConfig.epochs
    target_train_match_rate = args.target_train_match_rate

    ensure_parent_dir(model_save_path)
    ensure_parent_dir(metrics_path)
    ensure_dir(tensorboard_dir)

    update_manifest(
        artifacts.manifest_path,
        {
            **artifacts.manifest_defaults(),
            "bootstrap_train": {
                "data_path": data_path,
                "base_model_path": base_model_path,
                "model_save_path": model_save_path,
                "metrics_path": metrics_path,
                "tensorboard_dir": tensorboard_dir,
                "epoch_target": epochs,
                "target_train_match_rate": target_train_match_rate,
                "log_path": getattr(
                    logger, "log_path", artifacts.log_artifact_path("bootstrap.log")
                ),
            },
        },
    )

    all_records, labeled_slates = load_labeled_slates(data_path)
    if not labeled_slates:
        raise ValueError("No teacher-labeled bootstrap slates were found")

    encoder = UnifiedFeatureEncoder()
    train_encoded = featurize_labeled_slates(labeled_slates, encoder)
    grouped_batches = prepare_grouped_slate_batches(train_encoded)
    logger.info(
        "Prepared %d slates into %d candidate-count buckets",
        len(train_encoded),
        len(grouped_batches),
    )

    model = TreeLRUNet(in_features=encoder.in_features).to(device)
    if base_model_path:
        model.load_state_dict(torch.load(base_model_path, map_location=device))
        logger.info("Loaded base model parameters from %s", base_model_path)
    optimizer = optim.Adam(model.parameters(), lr=1e-3)

    (
        epoch_rows,
        best_train_loss,
        best_train_match_count,
        best_train_match_rate,
        best_state,
        stopped_early,
    ) = train_bootstrap_model(
        model,
        grouped_batches,
        optimizer,
        tensorboard_dir,
        epochs,
        target_train_match_rate=target_train_match_rate,
    )

    model.load_state_dict(best_state)
    save_bootstrap_state_dict(model, model_save_path)
    with open(metrics_path, "w") as f:
        f.write("epoch,train_loss,train_match_rate\n")
        for epoch, train_loss, train_match_rate in epoch_rows:
            f.write(f"{epoch},{train_loss},{train_match_rate}\n")

    update_manifest(
        artifacts.manifest_path,
        {
            "bootstrap_train": {
                "raw_slate_count": len(all_records),
                "train_slate_count": len(train_encoded),
                "skipped_unlabeled_count": len(all_records) - len(labeled_slates),
                "best_train_loss": best_train_loss,
                "best_train_match_count": best_train_match_count,
                "best_train_match_rate": best_train_match_rate,
                "epoch_count": len(epoch_rows),
                "stopped_early": stopped_early,
                "model_path": model_save_path,
                "metrics_path": metrics_path,
                "tensorboard_dir": tensorboard_dir,
            },
        },
    )
