import argparse
import json
import os
import random
import re
import shutil
import signal
import subprocess
import tempfile
import time

import numpy as np

from config import (
    DEFAULT_BENCHMARK,
    OFFLINE_TRAIN_EARLY_STOP_CONF_KEY,
    TestConfig,
    ensure_dir,
    ensure_parent_dir,
    read_spark_bool_conf,
    update_manifest,
    write_json_atomic,
)
from utils.logger import setup_custom_logger


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--method", default="test")
    parser.add_argument("--database")
    parser.add_argument("--benchmark", default=DEFAULT_BENCHMARK)
    parser.add_argument("--max-retry", type=int, default=3)
    parser.add_argument("--repeats", type=int, default=1)
    parser.add_argument("--save-latency", action="store_true", default=False)
    parser.add_argument("--save-path")
    parser.add_argument("--conf-path")
    parser.add_argument("--run-id")
    parser.add_argument("--sqldir")
    return parser.parse_args()


random.seed(3407)
args = parse_args()
logger = setup_custom_logger("TEST")
cfg = TestConfig(**vars(args))
EARLY_STOPPED_DUPLICATE = -2


def stage_log_path():
    return getattr(logger, "log_path", cfg.artifacts.log_artifact_path(f"{cfg.method}.log"))


def prepare_run_conf():
    conf_name = f"{cfg.method}.conf"
    run_conf_path = cfg.artifacts.conf_artifact_path(conf_name)
    ensure_dir(str(cfg.artifacts.conf_dir))
    ensure_parent_dir(run_conf_path)
    if os.path.abspath(cfg.conf_path) != os.path.abspath(run_conf_path):
        shutil.copyfile(cfg.conf_path, run_conf_path)
    return run_conf_path


cfg.conf_path = prepare_run_conf()
cfg.offline_train_early_stop_enabled = (
    cfg.method == "offline_train"
    and read_spark_bool_conf(cfg.conf_path, OFFLINE_TRAIN_EARLY_STOP_CONF_KEY, default=False)
)

update_manifest(
    cfg.artifacts.manifest_path,
    {
        **cfg.artifacts.manifest_defaults(),
        "evaluation": {
            cfg.method: {
                "method": cfg.method,
                "database": cfg.database,
                "benchmark": cfg.benchmark,
                "run_id": cfg.run_id,
                "max_retry": cfg.max_retry,
                "repeats": cfg.repeats,
                "sqldir": cfg.benchmark_path,
                "conf_path": cfg.conf_path,
                "log_path": stage_log_path(),
                "early_stop_on_duplicate_physical_plan": (
                    cfg.offline_train_early_stop_enabled
                ),
            },
        },
    },
)


def remove_file_if_exists(path):
    try:
        os.remove(path)
    except FileNotFoundError:
        pass


def clear_early_stop_event():
    remove_file_if_exists(cfg.artifacts.early_stop_event_path)


def clear_active_spark_submit():
    remove_file_if_exists(cfg.artifacts.active_spark_submit_path)


def register_active_spark_submit(process, query_path, session_name):
    if not cfg.offline_train_early_stop_enabled:
        return

    try:
        pgid = os.getpgid(process.pid)
    except ProcessLookupError:
        logger.warning(
            "SparkSubmit process disappeared before early-stop registration: %s",
            process.pid,
        )
        return

    write_json_atomic(
        cfg.artifacts.active_spark_submit_path,
        {
            "pid": process.pid,
            "pgid": pgid,
            "session_name": session_name,
            "query_path": query_path,
            "query_file": os.path.basename(query_path),
            "method": cfg.method,
            "benchmark": cfg.benchmark,
            "run_id": cfg.run_id,
            "early_stop_duplicates": True,
            "started_at": time.time(),
            "started_at_ns": time.time_ns(),
        },
    )


def consume_early_stop_event(session_name):
    if not cfg.offline_train_early_stop_enabled:
        return None

    path = cfg.artifacts.early_stop_event_path
    if not os.path.exists(path):
        return None

    try:
        with open(path, "r") as f:
            event = json.load(f)
    except (OSError, json.JSONDecodeError):
        logger.warning("Failed to read early-stop event file: %s", path)
        return None

    if event.get("session_name") != session_name:
        return None

    remove_file_if_exists(path)
    return event


def execute(query_path):
    cur_time = int(round(time.time() * 1000))
    tmp_path = None

    if cfg.explain_only:
        with open(query_path, "r") as f:
            original_sql = f.read().strip()
        explain_sql = f"EXPLAIN EXTENDED {original_sql}"
        tmp_fd, tmp_path = tempfile.mkstemp(suffix=".sql", prefix="explain_")
        with os.fdopen(tmp_fd, "w") as tmp_file:
            tmp_file.write(explain_sql)
        sql_path = tmp_path
    else:
        sql_path = query_path

    session_name = f"{cur_time}-{os.path.basename(query_path)}"
    cmd = [
        "spark-sql",
        "--database",
        cfg.database,
        "-f",
        sql_path,
        "--name",
        session_name,
        "--properties-file",
        cfg.conf_path,
    ]
    env = os.environ.copy()

    elapsed_time_usecs = -1
    try:
        for _ in range(cfg.max_retry):
            process = None
            clear_early_stop_event()
            try:
                process = subprocess.Popen(
                    cmd,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    start_new_session=True,
                    universal_newlines=True,
                    cwd=cfg.working_dir,
                    env=env,
                )
                register_active_spark_submit(process, query_path, session_name)
                output, _ = process.communicate(timeout=cfg.timeout)
                early_stop_event = consume_early_stop_event(session_name)
                if early_stop_event is not None:
                    logger.info(
                        "Early stopped %s after duplicated physical plan %s",
                        os.path.basename(query_path),
                        early_stop_event.get("plan_hash", ""),
                    )
                    elapsed_time_usecs = EARLY_STOPPED_DUPLICATE
                    break
                m = re.search(r"Time taken: (\d*.\d*) seconds", output)
                if m is None:
                    logger.warning("Execution finished but no elapsed time found, try again...")
                    elapsed_time_usecs = cfg.timeout
                else:
                    elapsed_time_usecs = float(m.group(1))
                    break
            except subprocess.TimeoutExpired:
                logger.warning("Execution Timeout.")
                if process is not None:
                    try:
                        os.killpg(process.pid, signal.SIGKILL)
                    except OSError:
                        pass
                elapsed_time_usecs = cfg.timeout
                break
            except Exception:
                logger.exception("Execution failed.")
                if process is not None:
                    try:
                        os.killpg(process.pid, signal.SIGKILL)
                    except OSError:
                        pass
                elapsed_time_usecs = -1
                break
            finally:
                clear_active_spark_submit()
    finally:
        if tmp_path is not None and os.path.exists(tmp_path):
            os.remove(tmp_path)

    return elapsed_time_usecs


def test(f_list):
    data = {}
    time_sum_list = []
    for sql in f_list:
        data[sql] = []
    for i in range(cfg.repeats):
        time_sum = 0
        for f_name in f_list:
            logger.info(f"Running {f_name}...")
            f_path = os.path.join(f"{cfg.benchmark_path}", f_name)
            t = execute(f_path)
            if t == EARLY_STOPPED_DUPLICATE:
                logger.info(
                    f"Early stopped duplicated physical plan for {f_name}, skipping this one..."
                )
                continue
            if t == -1:
                logger.error(f"Execution failed for {f_name}, skipping this one...")
                continue
            data[f_name].append(t)
            logger.info(f"{i + 1}th execution time of {f_name}: {t}s")
            time_sum += t
        logger.info(f"{i + 1}th execution time: {time_sum}s")
        time_sum_list.append(time_sum)
    mean = np.mean(time_sum_list)
    std = np.std(time_sum_list)
    logger.info(f"Mean: {mean}, Std: {std}")
    for k, v in data.items():
        data[k] = sum(v) / len(v) if v else -1
    return data


def save(data, save_path):
    ensure_parent_dir(save_path)
    with open(save_path, "w") as f:
        json.dump(data, f, indent=4)
        logger.info(f"Saved data to {save_path}")


if __name__ == "__main__":
    org_f_list = sorted(
        f_name for f_name in os.listdir(cfg.benchmark_path) if f_name.endswith('.sql')
    )
    logger.info("Found the following SQL files in %s: %s", cfg.benchmark_path, org_f_list)
    if cfg.explain_only:
        logger.info("Running on EXPLAIN only mode")
    org_data = test(org_f_list)
    evaluation_updates = {
        "log_path": stage_log_path(),
        "conf_path": cfg.conf_path,
    }
    if cfg.save_latency:
        save(org_data, cfg.save_path)
        evaluation_updates.update({
            "save_path": cfg.save_path,
            "query_count": len(org_data),
        })

    update_manifest(
        cfg.artifacts.manifest_path,
        {
            "evaluation": {
                cfg.method: evaluation_updates,
            },
        },
    )
