import argparse
import hashlib
import json
import os
import signal

from fastapi import FastAPI
import time
import torch
import uvicorn

from config import (
    DEFAULT_BENCHMARK,
    ensure_parent_dir,
    get_run_artifacts,
    update_manifest,
    write_json_atomic,
)
from preprocessor.sparkplanpreprocessor import SparkPlanPreprocessor
from request_models import CostRequest, CostResponse, RegisterRequest, plan_info_to_dict
from utils.logger import setup_custom_logger


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark", default=DEFAULT_BENCHMARK)
    parser.add_argument("--run-id")
    parser.add_argument("--port", type=int, default=10533)
    return parser.parse_args()


args = parse_args()
logger = setup_custom_logger("SERVER")
preprocessor = SparkPlanPreprocessor()
artifacts = get_run_artifacts(args.benchmark, args.run_id)

app = FastAPI()


def is_aqe_plan(plan_info_dict, plan_type=None):
    if plan_type is not None:
        return plan_type == 2
    return bool(plan_info_dict.get("queryStages"))


def get_advisory_index(request):
    if 0 <= request.advisoryChoose < len(request.candidates):
        return request.advisoryChoose
    logger.warning(
        f"Invalid advisoryChoose={request.advisoryChoose}; defaulting to candidate 0"
    )
    return 0


def get_plan_hash(plan_info, plan_type=None):
    plan_info_dict = plan_info_to_dict(plan_info)
    payload = {
        "plan": plan_info_dict.get("plan"),
        "card": plan_info_dict.get("card"),
        "size": plan_info_dict.get("size"),
    }
    if not is_aqe_plan(plan_info_dict, plan_type=plan_type):
        query_stages = plan_info_dict.get("queryStages", {})
        payload["queryStages"] = {
            key: query_stages[key]
            for key in sorted(query_stages)
        }
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()


def load_existing_data_collection(path):
    if not os.path.exists(path):
        return [], set()

    records = torch.load(path)
    hashes = set()
    for record in records:
        try:
            plan_info = record["x"]["plan_info"]
            hashes.add(get_plan_hash(plan_info))
        except (KeyError, TypeError):
            continue
    return records, hashes


plan_pool = []
data_collection, data_collection_hashes = load_existing_data_collection(artifacts.raw_training_data_path)
last_logical_plan_info = None
last_physical_plan_info = None
early_stop_duplicate_physical_plan_count = 0


def flush_pending_buffered_plans():
    global last_logical_plan_info, last_physical_plan_info, plan_pool

    if last_logical_plan_info is not None:
        plan_pool.append(last_logical_plan_info)
        logger.info(
            f"Saved plan: 0 {last_logical_plan_info[0].plan[:100]} {last_logical_plan_info[1]}"
        )
        last_logical_plan_info = None

    if last_physical_plan_info is not None:
        plan_pool.append(last_physical_plan_info)
        logger.info(
            f"Saved plan: 1 {last_physical_plan_info[0].plan[:100]} {last_physical_plan_info[1]}"
        )
        last_physical_plan_info = None


def discard_pending_plans(reason):
    global last_logical_plan_info, last_physical_plan_info, plan_pool

    discarded_cnt = len(plan_pool)
    if last_logical_plan_info is not None:
        discarded_cnt += 1
    if last_physical_plan_info is not None:
        discarded_cnt += 1

    plan_pool = []
    last_logical_plan_info = None
    last_physical_plan_info = None

    if discarded_cnt:
        logger.info(f"Discarded {discarded_cnt} pending plans because {reason}")


def read_active_spark_submit():
    path = artifacts.active_spark_submit_path
    if not os.path.exists(path):
        return None
    try:
        with open(path, "r") as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        logger.warning(f"Failed to read active SparkSubmit metadata from {path}: {exc}")
        return None


def get_process_cmdline(pid):
    try:
        with open(f"/proc/{pid}/cmdline", "rb") as f:
            return f.read().replace(b"\x00", b" ").decode("utf-8", errors="replace")
    except OSError:
        return ""


def kill_active_spark_submit(reason, plan_hash):
    active = read_active_spark_submit()
    if active is None:
        logger.warning(
            f"Cannot early stop duplicate physical plan {plan_hash}: no active SparkSubmit metadata"
        )
        return False

    if not active.get("early_stop_duplicates", False):
        logger.info("Duplicate physical plan detected, but early stop is disabled for this run")
        return False

    if active.get("run_id") != artifacts.run_id or active.get("benchmark") != artifacts.benchmark:
        logger.warning(f"Refusing early stop from stale metadata: {active}")
        return False

    started_at = active.get("started_at")
    if started_at is not None:
        try:
            active_age = time.time() - float(started_at)
        except (TypeError, ValueError):
            logger.warning(f"Invalid active SparkSubmit metadata: {active}")
            return False
        if active_age > 3600:
            logger.warning(f"Refusing early stop from expired SparkSubmit metadata: {active}")
            return False

    try:
        pid = int(active["pid"])
        pgid = int(active.get("pgid", pid))
    except (KeyError, TypeError, ValueError):
        logger.warning(f"Invalid active SparkSubmit metadata: {active}")
        return False

    try:
        current_pgid = os.getpgid(pid)
    except ProcessLookupError:
        logger.warning(f"SparkSubmit PID {pid} already exited before early stop")
        return False

    if current_pgid != pgid:
        logger.warning(
            f"Refusing to kill SparkSubmit PID {pid}: expected pgid {pgid}, got {current_pgid}"
        )
        return False

    cmdline = get_process_cmdline(pid)
    if cmdline and not any(
        marker in cmdline
        for marker in ("spark-sql", "spark-submit", "org.apache.spark.deploy.SparkSubmit")
    ):
        logger.warning(f"Refusing to kill PID {pid}: command does not look like SparkSubmit")
        return False

    event = {
        "reason": reason,
        "plan_hash": plan_hash,
        "pid": pid,
        "pgid": pgid,
        "session_name": active.get("session_name"),
        "query_path": active.get("query_path"),
        "query_file": active.get("query_file"),
        "run_id": artifacts.run_id,
        "benchmark": artifacts.benchmark,
        "stopped_at": time.time(),
        "stopped_at_ns": time.time_ns(),
    }
    write_json_atomic(artifacts.early_stop_event_path, event)

    try:
        os.killpg(pgid, signal.SIGKILL)
    except ProcessLookupError:
        logger.warning(f"SparkSubmit process group {pgid} already exited before early stop")
        try:
            os.remove(artifacts.early_stop_event_path)
        except FileNotFoundError:
            pass
        return False
    except OSError as exc:
        logger.warning(f"Failed to early stop SparkSubmit process group {pgid}: {exc}")
        try:
            os.remove(artifacts.early_stop_event_path)
        except FileNotFoundError:
            pass
        return False

    logger.info(
        f"Early stopped SparkSubmit pgid {pgid} for {active.get('session_name')} "
        f"because duplicate physical plan {plan_hash} was already collected"
    )
    return True


def maybe_early_stop_duplicate_physical_plan(plan_info, plan_type):
    global early_stop_duplicate_physical_plan_count

    plan_hash = get_plan_hash(plan_info, plan_type=plan_type)
    if plan_hash not in data_collection_hashes:
        return False

    stopped = kill_active_spark_submit(
        "duplicate physical plan already collected",
        plan_hash,
    )
    if not stopped:
        return False

    early_stop_duplicate_physical_plan_count += 1
    discard_pending_plans("duplicate physical plan was early-stopped")
    update_manifest(
        artifacts.manifest_path,
        {
            **artifacts.manifest_defaults(),
            "collection": {
                "early_stop_duplicate_physical_plan_count": (
                    early_stop_duplicate_physical_plan_count
                ),
                "last_early_stop_event_path": artifacts.early_stop_event_path,
                "log_path": getattr(
                    logger,
                    "log_path",
                    artifacts.log_artifact_path("offline_train_server.log"),
                ),
            },
        },
    )
    return True


@app.post("/cost")
async def receive_plan(request: CostRequest):
    global last_logical_plan_info, last_physical_plan_info, plan_pool
    if not request.candidates:
        logger.warning("Received empty /cost candidate list")
        return CostResponse(costs=[])

    tree = preprocessor.plan2tree(request.candidates[0])
    if len(tree) > 3:
        if request.type == 0:
            last_logical_plan_info = (request.candidates[0], time.time_ns(), request.type)
            return CostResponse(costs=[0])

        if request.type == 1:
            advisory_index = get_advisory_index(request)
            selected_candidate = request.candidates[advisory_index]
            if maybe_early_stop_duplicate_physical_plan(
                selected_candidate,
                request.type,
            ):
                return CostResponse(costs=[0] * len(request.candidates))
            last_physical_plan_info = (selected_candidate, time.time_ns(), request.type)
            costs = [1.0] * len(request.candidates)
            costs[advisory_index] = 0.0
            return CostResponse(costs=costs)

        if request.type == 2:
            flush_pending_buffered_plans()
            plan_pool.append((request.candidates[0], time.time_ns(), request.type))
            clean_query_stages = {
                k: v.model_dump(exclude={"stagePlan"})
                for k, v in request.candidates[0].queryStages.items()
            }

            logger.info(
                f"Saved plan: 2 {request.candidates[0].plan[:100]} {clean_query_stages} {time.time_ns()}"
            )
            return CostResponse(costs=[0])
    return CostResponse(costs=[0])


@app.post("/register")
async def register_plan(request: RegisterRequest):
    global plan_pool, data_collection, data_collection_hashes, last_logical_plan_info, last_physical_plan_info
    current_time = time.time_ns()
    saved_cnt = 0
    duplicate_cnt = 0

    if request.executionTime <= 0:
        logger.warning(
            f"Something went wrong while executing {request.sessionName}, still registering training plans though..."
        )

    flush_pending_buffered_plans()

    for plan_info, time_stamp, plan_type in plan_pool:
        label = current_time - time_stamp if request.executionTime > 0 else 300_000_000_000

        plan_hash = get_plan_hash(plan_info, plan_type=plan_type)
        if plan_hash in data_collection_hashes:
            duplicate_cnt += 1
            continue

        data_collection.append(
            {
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
        )
        data_collection_hashes.add(plan_hash)
        saved_cnt += 1

    if saved_cnt:
        save_path = artifacts.raw_training_data_path
        ensure_parent_dir(save_path)
        torch.save(data_collection, save_path)
        update_manifest(
            artifacts.manifest_path,
            {
                **artifacts.manifest_defaults(),
                "collection": {
                    "raw_training_data_path": save_path,
                    "registered_queries": len(data_collection),
                    "log_path": getattr(logger, "log_path", artifacts.log_artifact_path("offline_train_server.log")),
                },
            },
        )
    logger.info(
        f"Registered {saved_cnt} new training plans for {request.sessionName}; skipped {duplicate_cnt} duplicates; total stored plans: {len(data_collection)}"
    )
    plan_pool = []
    last_logical_plan_info = None
    last_physical_plan_info = None
    return {}


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=args.port)
