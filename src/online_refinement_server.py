import argparse
import csv
import hashlib
import json
import math
import os
import random
import time

import torch
import uvicorn
from fastapi import FastAPI
from torch import nn, optim

from config import (
    DEFAULT_BENCHMARK,
    EnvironmentConfig,
    TrainConfig,
    ensure_parent_dir,
    get_run_artifacts,
    update_manifest,
)
from model_runtime import (
    create_model,
    load_model_state,
    prepare_model_batch,
)
from models.encoder import UnifiedFeatureEncoder
from preprocessor.sparkplanpreprocessor import SparkPlanPreprocessor
from request_models import CostRequest, CostResponse, RegisterRequest, plan_info_to_dict
from utils.logger import setup_custom_logger


MIN_PREDICTION_SECONDS = 1.0
UNSELECTED_COST = 1_000_000.0


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", default=DEFAULT_BENCHMARK)
    parser.add_argument("--database")
    parser.add_argument("--table-key")
    parser.add_argument("--run-id")
    parser.add_argument("--model-path")
    parser.add_argument("--model-save-path")
    parser.add_argument("--port", type=int, default=10533)
    parser.add_argument("--online-batch-size", type=int, default=32)
    parser.add_argument("--online-lr", type=float, default=1e-4)
    parser.add_argument("--online-update-epochs", type=int, default=1)
    parser.add_argument("--seed", type=int, default=3407)
    return parser.parse_args()


args = parse_args()
logger = setup_custom_logger("ONLINE")
rng = random.Random(args.seed)
artifacts = get_run_artifacts(args.benchmark, args.run_id)
TrainConfig.current_time = artifacts.run_id

EnvironmentConfig.configure_for_benchmark(
    args.benchmark,
    database=args.database,
    table_key=args.table_key,
)
if args.model_path:
    model_path = args.model_path
elif args.run_id or os.getenv("CALIBRA_RUN_ID"):
    model_path = artifacts.model_path
else:
    raise ValueError(
        "online_refinement_server requires --model-path or --run-id for a trained "
        "Calibra run; this release does not include pretrained model defaults."
    )
model_save_path = args.model_save_path or artifacts.online_model_path

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
preprocessor = SparkPlanPreprocessor()
encoder = UnifiedFeatureEncoder()
model = create_model(in_features=encoder.in_features).to(device)
load_model_state(model, model_path, device)
model.eval()
optimizer = optim.Adam(model.parameters(), lr=args.online_lr)
loss_fn = nn.MSELoss()
app = FastAPI()

plan_pool = []
last_logical_plan_info = None
last_physical_plan_info = None
pending_update_records = []
online_update_step = 0


def sigmoid(value):
    if value >= 0:
        z = math.exp(-value)
        return 1.0 / (1.0 + z)
    z = math.exp(value)
    return z / (1.0 + z)


def get_advisory_index(request):
    if 0 <= request.advisoryChoose < len(request.candidates):
        return request.advisoryChoose
    return 0


def infer_decision_kind(request):
    if request.decisionKind:
        return request.decisionKind
    if len(request.candidates) <= 1:
        return "scalar"
    if len(request.candidates) == 2:
        return "pairwise"
    return "listwise"


def infer_select_k(request):
    if request.selectK is not None and request.selectK > 0:
        return min(request.selectK, len(request.candidates))
    return 1


def get_plan_hash(plan_info, plan_type=None):
    plan_info_dict = plan_info_to_dict(plan_info)
    payload = {
        "plan": plan_info_dict.get("plan"),
        "card": plan_info_dict.get("card"),
        "size": plan_info_dict.get("size"),
        "type": plan_type,
    }
    query_stages = plan_info_dict.get("queryStages", {})
    payload["queryStages"] = {
        key: query_stages[key]
        for key in sorted(query_stages)
    }
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def load_existing_collection(path):
    if not os.path.exists(path):
        return [], set()
    records = torch.load(path)
    hashes = set()
    for record in records:
        try:
            hashes.add(get_plan_hash(record["x"]["plan_info"]))
        except (KeyError, TypeError):
            continue
    return records, hashes


data_collection, data_collection_hashes = load_existing_collection(
    artifacts.online_training_data_path
)


def encode_records(records):
    return [
        encoder.featurize(preprocessor.plan2tree(record["x"]["plan_info"]))
        for record in records
    ]


def predict_costs(candidates):
    trees = [preprocessor.plan2tree(plan_info) for plan_info in candidates]
    encoded = [encoder.featurize(tree) for tree in trees]
    with torch.no_grad():
        pred = model(prepare_model_batch(encoded))
    costs = pred.squeeze(dim=1).tolist()
    return [max(float(cost), MIN_PREDICTION_SECONDS) for cost in costs], trees


def choose_pairwise(raw_costs):
    if len(raw_costs) != 2:
        selected = min(range(len(raw_costs)), key=lambda idx: raw_costs[idx])
        return [selected], {"probability": 1.0, "preferred": selected}

    if raw_costs[0] <= raw_costs[1]:
        preferred, other = 0, 1
        probability = sigmoid(raw_costs[1] - raw_costs[0])
    else:
        preferred, other = 1, 0
        probability = sigmoid(raw_costs[0] - raw_costs[1])
    selected = preferred if rng.random() < probability else other
    return [selected], {"probability": probability, "preferred": preferred}


def choose_listwise(raw_costs, select_k):
    remaining = list(range(len(raw_costs)))
    if len(remaining) <= select_k:
        return remaining, {"mode": "all"}

    selected = []
    draw_probabilities = []
    while len(selected) < select_k and remaining:
        logits = [-float(raw_costs[idx]) for idx in remaining]
        max_logit = max(logits)
        weights = [math.exp(logit - max_logit) for logit in logits]
        total_weight = sum(weights)

        if total_weight <= 0.0 or not math.isfinite(total_weight):
            probabilities = [1.0 / len(remaining)] * len(remaining)
        else:
            probabilities = [weight / total_weight for weight in weights]

        threshold = rng.random()
        cumulative = 0.0
        chosen_position = len(remaining) - 1
        for position, probability in enumerate(probabilities):
            cumulative += probability
            if threshold <= cumulative:
                chosen_position = position
                break

        chosen_index = remaining.pop(chosen_position)
        selected.append(chosen_index)
        draw_probabilities.append(probabilities[chosen_position])

    return selected, {
        "mode": "softmax_without_replacement",
        "draw_probabilities": draw_probabilities,
    }


def costs_for_selection(raw_costs, selected_indices, decision_kind):
    if decision_kind == "scalar":
        return raw_costs

    selected_rank = {idx: rank for rank, idx in enumerate(selected_indices)}
    shaped = []
    for idx, raw_cost in enumerate(raw_costs):
        if idx in selected_rank:
            shaped.append(float(selected_rank[idx]))
        else:
            shaped.append(UNSELECTED_COST + float(idx) + raw_cost * 1e-6)
    return shaped


def record_selected_plan(request, selected_indices):
    global last_logical_plan_info, last_physical_plan_info
    if not selected_indices:
        return
    selected_index = selected_indices[0]
    plan_info = request.candidates[selected_index]
    try:
        tree = preprocessor.plan2tree(plan_info)
    except Exception:
        logger.exception("Failed to parse selected plan for online collection")
        return
    if len(tree) <= 3:
        return

    if request.type == 0:
        last_logical_plan_info = (plan_info, time.time_ns(), request.type)
    elif request.type == 1:
        last_physical_plan_info = (plan_info, time.time_ns(), request.type)
    elif request.type == 2:
        flush_pending_buffered_plans()
        plan_pool.append((plan_info, time.time_ns(), request.type))


def flush_pending_buffered_plans():
    global last_logical_plan_info, last_physical_plan_info
    if last_logical_plan_info is not None:
        plan_pool.append(last_logical_plan_info)
        last_logical_plan_info = None
    if last_physical_plan_info is not None:
        plan_pool.append(last_physical_plan_info)
        last_physical_plan_info = None


def run_online_update():
    global pending_update_records, online_update_step
    if len(pending_update_records) < args.online_batch_size:
        return None

    batch_records = pending_update_records[:args.online_batch_size]
    pending_update_records = pending_update_records[args.online_batch_size:]
    encoded_plans = encode_records(batch_records)
    labels = torch.tensor(
        [record["y"] / 1_000_000_000 for record in batch_records],
        dtype=torch.float32,
    ).view(-1, 1).to(device)

    model.train()
    last_loss = None
    for _ in range(args.online_update_epochs):
        pred = model(prepare_model_batch(encoded_plans))
        loss = loss_fn(pred, labels)
        optimizer.zero_grad(set_to_none=True)
        loss.backward()
        optimizer.step()
        last_loss = float(loss.item())
    model.eval()

    online_update_step += 1
    ensure_parent_dir(model_save_path)
    torch.save(model.state_dict(), model_save_path)

    ensure_parent_dir(artifacts.online_metrics_path)
    write_header = not os.path.exists(artifacts.online_metrics_path)
    with open(artifacts.online_metrics_path, "a", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "step",
                "loss",
                "batch_size",
                "total_online_samples",
                "model_path",
            ],
        )
        if write_header:
            writer.writeheader()
        writer.writerow(
            {
                "step": online_update_step,
                "loss": last_loss,
                "batch_size": len(batch_records),
                "total_online_samples": len(data_collection),
                "model_path": model_save_path,
            }
        )
    logger.info(
        "Online update %s finished: loss=%.6f batch_size=%s total_online_samples=%s",
        online_update_step,
        last_loss,
        len(batch_records),
        len(data_collection),
    )
    return last_loss


@app.post("/cost")
async def receive_plan(request: CostRequest):
    if not request.candidates:
        return CostResponse(costs=[])

    raw_costs, _ = predict_costs(request.candidates)
    decision_kind = infer_decision_kind(request)
    select_k = infer_select_k(request)

    if decision_kind == "pairwise":
        selected_indices, decision_info = choose_pairwise(raw_costs)
    elif decision_kind == "listwise":
        selected_indices, decision_info = choose_listwise(raw_costs, select_k)
    else:
        selected_indices = [get_advisory_index(request)]
        decision_info = {"mode": "scalar"}

    returned_costs = costs_for_selection(raw_costs, selected_indices, decision_kind)
    record_selected_plan(request, selected_indices)
    logger.info(
        "Online %s decision type=%s select_k=%s raw=%s selected=%s returned=%s info=%s",
        decision_kind,
        request.type,
        select_k,
        raw_costs,
        selected_indices,
        returned_costs,
        decision_info,
    )
    return CostResponse(costs=returned_costs)


@app.post("/register")
async def register_plan(request: RegisterRequest):
    global plan_pool, last_logical_plan_info, last_physical_plan_info
    current_time = time.time_ns()
    saved_cnt = 0
    duplicate_cnt = 0

    flush_pending_buffered_plans()
    for plan_info, time_stamp, plan_type in plan_pool:
        label = current_time - time_stamp if request.executionTime > 0 else 300_000_000_000
        plan_hash = get_plan_hash(plan_info, plan_type=plan_type)
        if plan_hash in data_collection_hashes:
            duplicate_cnt += 1
            continue
        record = {
            "x": {
                "query_id": request.sessionName,
                "plan_info": plan_info,
                "plan_type": plan_type,
                "sample_type": {0: "lp", 1: "pp", 2: "pmp"}.get(
                    plan_type, str(plan_type)
                ),
            },
            "y": label,
        }
        data_collection.append(record)
        pending_update_records.append(record)
        data_collection_hashes.add(plan_hash)
        saved_cnt += 1

    if saved_cnt:
        ensure_parent_dir(artifacts.online_training_data_path)
        torch.save(data_collection, artifacts.online_training_data_path)

    loss = run_online_update()
    update_manifest(
        artifacts.manifest_path,
        {
            **artifacts.manifest_defaults(),
            "online_refinement": {
                "base_model_path": model_path,
                "model_path": model_save_path,
                "online_training_data_path": artifacts.online_training_data_path,
                "online_metrics_path": artifacts.online_metrics_path,
                "listwise_selection": "cost_softmax_without_replacement",
                "online_batch_size": args.online_batch_size,
                "online_lr": args.online_lr,
                "online_update_epochs": args.online_update_epochs,
                "saved_online_samples": len(data_collection),
                "pending_update_samples": len(pending_update_records),
                "online_update_step": online_update_step,
                "last_update_loss": loss,
                "log_path": getattr(
                    logger,
                    "log_path",
                    artifacts.log_artifact_path("online_refinement_server.log"),
                ),
            },
        },
    )
    logger.info(
        "Registered online samples for %s: saved=%s duplicate=%s total=%s pending=%s",
        request.sessionName,
        saved_cnt,
        duplicate_cnt,
        len(data_collection),
        len(pending_update_records),
    )
    plan_pool = []
    last_logical_plan_info = None
    last_physical_plan_info = None
    return {}


if __name__ == "__main__":
    update_manifest(
        artifacts.manifest_path,
        {
            **artifacts.manifest_defaults(),
            "online_refinement": {
                "base_model_path": model_path,
                "model_path": model_save_path,
                "online_training_data_path": artifacts.online_training_data_path,
                "online_metrics_path": artifacts.online_metrics_path,
                "listwise_selection": "cost_softmax_without_replacement",
                "online_batch_size": args.online_batch_size,
                "online_lr": args.online_lr,
                "online_update_epochs": args.online_update_epochs,
                "port": args.port,
                "log_path": getattr(
                    logger,
                    "log_path",
                    artifacts.log_artifact_path("online_refinement_server.log"),
                ),
            },
        },
    )
    logger.info("Loaded online base model from %s", model_path)
    uvicorn.run(app, host="localhost", port=args.port)
