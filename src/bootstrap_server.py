import argparse
import hashlib
import json
import re
import time
from pathlib import Path

import torch
import uvicorn
from fastapi import FastAPI

from config import (
    DEFAULT_BENCHMARK,
    ensure_parent_dir,
    get_run_artifacts,
    get_teacher_plan_root,
    update_manifest,
)
from preprocessor.plan_signature import (
    build_candidate_descriptors,
    load_plan_signatures_by_query,
    logical_plan_descriptor,
)
from preprocessor.sparkplanpreprocessor import SparkPlanPreprocessor
from request_models import CostRequest, CostResponse, RegisterRequest, plan_info_to_dict
from teacher_matching import (
    label_slate_with_teacher,
    same_subset as signatures_same_subset,
    slate_selection_kind,
)
from utils.logger import setup_custom_logger


TIMESTAMP_QUERY_ID_RE = re.compile(r"^\d+-(.+)$")
IGNORED_PLAN_PREFIXES = (
    "CommandResult",
    "SetCatalogAndNamespace",
    "ExplainCommand",
)
DEFAULT_TEACHER_ROOT = get_teacher_plan_root("cbo")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", default=DEFAULT_BENCHMARK)
    parser.add_argument("--run-id")
    parser.add_argument("--port", type=int, default=10533)
    parser.add_argument(
        "--teacher-root",
        help="Directory containing CBO teacher plans; defaults to references/teacher_plans/cbo.",
    )
    return parser.parse_args()


args = parse_args()
logger = setup_custom_logger("SERVER")
artifacts = get_run_artifacts(args.benchmark, args.run_id)
preprocessor = SparkPlanPreprocessor()
app = FastAPI()
teacher_root = Path(args.teacher_root).expanduser() if args.teacher_root else DEFAULT_TEACHER_ROOT
teacher_response_source = "cbo_query"

pending_slates = []
pending_slate_hashes = set()
teacher_signatures_by_query = None
current_runtime_query_id = None


def normalize_query_id(query_id):
    if not isinstance(query_id, str):
        return query_id
    match = TIMESTAMP_QUERY_ID_RE.match(query_id)
    return match.group(1) if match else query_id


def candidate_hash(plan_info):
    payload = plan_info_to_dict(plan_info)
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def slate_hash(candidates, advisory_choose):
    payload = {
        "candidate_hashes": [candidate_hash(candidate) for candidate in candidates],
        "advisory_choose": advisory_choose,
    }
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def should_skip_candidate(plan_info):
    plan = plan_info.get("plan", "")
    return any(plan.startswith(prefix) for prefix in IGNORED_PLAN_PREFIXES)


def costs_from_choice(choice, candidate_count):
    costs = [1.0] * candidate_count
    costs[choice] = 0.0
    return costs


def costs_from_choices(choices, candidate_count):
    costs = [1.0] * candidate_count
    for choice in choices:
        costs[choice] = 0.0
    return costs


def default_costs(request):
    if request.type != 0:
        return [0.0] * len(request.candidates)
    return costs_from_choice(request.advisoryChoose, len(request.candidates))


def get_teacher_signatures_by_query():
    global teacher_signatures_by_query

    if teacher_signatures_by_query is None:
        teacher_signatures_by_query = load_plan_signatures_by_query(
            args.benchmark,
            teacher_root,
            preprocessor,
        )
    return teacher_signatures_by_query


def label_pending_slate(record, teacher_by_subset, query_id, signatures=None):
    if signatures is None:
        signatures = []
        for candidate in record["candidates"]:
            try:
                signatures.append(
                    logical_plan_descriptor(candidate, preprocessor, args.benchmark)
                )
            except Exception:
                return None, None, "missing_candidate_signature"

    teacher_choices, skip_reason = label_slate_with_teacher(teacher_by_subset, signatures)
    if teacher_choices is None:
        return None, None, skip_reason

    metadata = {
        "teacher_query_id": query_id,
        "teacher_source": teacher_response_source,
        "teacher_positive_count": len(teacher_choices),
    }
    is_same_subset = signatures_same_subset(signatures)
    if is_same_subset and len(record["candidates"]) == 2:
        metadata["pair_labeling"] = True
    elif not is_same_subset:
        metadata["inter_labeling"] = True
    return teacher_choices, metadata, None


def summarize_slate_record(record):
    shapes = record.get("candidate_shapes") or []
    return (
        "Bootstrap slate"
        f" request_index={record['request_index']}"
        f" query={record.get('query_context_id') or 'unknown'}"
        f" level={record.get('dp_level')}"
        f" kind={record.get('selection_kind')}"
        f" candidates={record['candidate_count']}"
        f" advisory={record['advisory_choose']}"
        f" response={record.get('response_choose')}"
        f" source={record.get('response_source')}"
        f" teacher={record.get('teacher_choices') or record.get('teacher_choice')}"
        f" skip={record.get('teacher_skip_reason')}"
        f" shapes={shapes}"
    )


def load_existing_slates(path):
    slate_path = Path(path)
    if not slate_path.exists():
        return [], set()

    records = torch.load(str(slate_path))
    hashes = set()
    for record in records:
        if "slate_hash" in record:
            hashes.add(record["slate_hash"])
            continue

        candidate_hashes = record.get("candidate_hashes")
        advisory_choose = record.get("advisory_choose")
        if candidate_hashes is None or advisory_choose is None:
            continue
        payload = {
            "candidate_hashes": candidate_hashes,
            "advisory_choose": advisory_choose,
        }
        hashes.add(hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest())
    return records, hashes


@app.post("/cost")
async def receive_plan(request: CostRequest):
    global pending_slates, pending_slate_hashes, current_runtime_query_id

    normalized_candidates = [plan_info_to_dict(candidate) for candidate in request.candidates]
    costs = default_costs(request)

    if normalized_candidates and all(
        should_skip_candidate(candidate) for candidate in normalized_candidates
    ):
        logger.info(
            "Skipping boilerplate slate: type=%s candidates=%s head=%s",
            request.type,
            len(normalized_candidates),
            normalized_candidates[0].get("plan", "").splitlines()[0],
        )
        return CostResponse(costs=costs)

    if request.type != 0 or len(normalized_candidates) <= 1:
        return CostResponse(costs=costs)

    this_slate_hash = slate_hash(request.candidates, request.advisoryChoose)
    if this_slate_hash in pending_slate_hashes:
        return CostResponse(costs=costs)

    teacher_choices = None
    teacher_metadata = None
    teacher_skip_reason = "missing_query_context"
    candidate_descriptors = []
    dp_level = 0
    response_choose = request.advisoryChoose
    response_source = "advisory"

    try:
        candidate_descriptors, _, dp_level = build_candidate_descriptors(
            normalized_candidates,
            preprocessor,
            args.benchmark,
        )
        if current_runtime_query_id is not None:
            teacher_by_subset = get_teacher_signatures_by_query().get(current_runtime_query_id)
            if teacher_by_subset is None:
                teacher_skip_reason = "missing_query_teacher_plan"
            else:
                teacher_choices, teacher_metadata, teacher_skip_reason = label_pending_slate(
                    {"candidates": normalized_candidates},
                    teacher_by_subset,
                    current_runtime_query_id,
                    signatures=candidate_descriptors,
                )
                if teacher_choices is not None:
                    response_choose = teacher_choices[0]
                    response_source = teacher_response_source
                    costs = costs_from_choices(teacher_choices, len(normalized_candidates))
    except Exception as exc:
        teacher_skip_reason = f"label_error:{exc}"

    record = {
        "query_id": None,
        "query_context_id": current_runtime_query_id,
        "advisory_choose": request.advisoryChoose,
        "candidate_count": len(request.candidates),
        "candidates": normalized_candidates,
        "candidate_hashes": [candidate_hash(candidate) for candidate in normalized_candidates],
        "candidate_shapes": [info["shape"] for info in candidate_descriptors],
        "dp_level": dp_level,
        "selection_kind": slate_selection_kind(candidate_descriptors),
        "response_choose": response_choose,
        "response_source": response_source,
        "slate_hash": this_slate_hash,
        "teacher_skip_reason": teacher_skip_reason,
        "collected_at_ns": time.time_ns(),
        "request_index": len(pending_slates),
    }
    if teacher_choices is not None:
        record["teacher_choices"] = teacher_choices
        if len(teacher_choices) == 1:
            record["teacher_choice"] = teacher_choices[0]
        if teacher_metadata:
            record.update(teacher_metadata)

    pending_slates.append(record)
    pending_slate_hashes.add(this_slate_hash)
    logger.info(summarize_slate_record(record))
    return CostResponse(costs=costs)


@app.post("/register")
async def register_plan(request: RegisterRequest):
    global pending_slates, pending_slate_hashes, current_runtime_query_id

    query_id = normalize_query_id(request.sessionName)
    current_runtime_query_id = query_id
    had_pending_slates = bool(pending_slates)
    teacher_by_subset = get_teacher_signatures_by_query().get(query_id)
    existing_records, existing_hashes = load_existing_slates(artifacts.bootstrap_data_path)

    new_records = []
    skipped_count = 0
    duplicate_count = 0

    for slate in pending_slates:
        labeled_record = dict(slate)
        labeled_record["query_id"] = request.sessionName

        teacher_choices = labeled_record.get("teacher_choices")
        if teacher_choices is None and labeled_record.get("teacher_choice") is not None:
            teacher_choices = [labeled_record["teacher_choice"]]

        if not teacher_choices:
            if teacher_by_subset is None:
                skipped_count += 1
                continue

            teacher_choices, metadata, skip_reason = label_pending_slate(
                labeled_record,
                teacher_by_subset,
                query_id,
            )
            if teacher_choices is None:
                logger.info(
                    "Skipping bootstrap slate request_index=%s query=%s reason=%s",
                    labeled_record["request_index"],
                    query_id,
                    skip_reason,
                )
                skipped_count += 1
                continue

            labeled_record["teacher_choices"] = teacher_choices
            labeled_record["teacher_skip_reason"] = None
            if len(teacher_choices) == 1:
                labeled_record["teacher_choice"] = teacher_choices[0]
            if metadata:
                labeled_record.update(metadata)

        if labeled_record["slate_hash"] in existing_hashes:
            duplicate_count += 1
            continue

        new_records.append(labeled_record)
        existing_hashes.add(labeled_record["slate_hash"])

    logger.info(
        "Registering bootstrap session=%s execution_time=%s collected=%s saved_labeled=%s skipped=%s duplicates=%s",
        request.sessionName,
        request.executionTime,
        len(pending_slates),
        len(new_records),
        skipped_count,
        duplicate_count,
    )

    save_records = existing_records + new_records
    if new_records:
        ensure_parent_dir(artifacts.bootstrap_data_path)
        torch.save(save_records, artifacts.bootstrap_data_path)
    update_manifest(
        artifacts.manifest_path,
        {
            **artifacts.manifest_defaults(),
            "bootstrap_collection": {
                "data_path": artifacts.bootstrap_data_path,
                "query_id": query_id,
                "teacher_kind": "cbo",
                "teacher_root": str(teacher_root),
                "saved_labeled_count": len(new_records),
                "collected_slate_count": len(pending_slates),
                "skipped_slate_count": skipped_count,
                "duplicate_slate_count": duplicate_count,
                "stored_slate_count": len(save_records),
                "log_path": getattr(logger, "log_path", artifacts.log_artifact_path("bootstrap_server.log")),
            },
        },
    )

    pending_slates = []
    pending_slate_hashes = set()
    if had_pending_slates:
        current_runtime_query_id = None
    return {}


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=args.port)
