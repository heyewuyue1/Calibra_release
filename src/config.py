from dataclasses import dataclass
from datetime import datetime
import json
import logging
import os
from pathlib import Path
import re


PROJECT_ROOT = Path(
    os.getenv("CALIBRA_PROJECT_ROOT", Path(__file__).resolve().parents[1])
).resolve()
PREFIX = str(PROJECT_ROOT)
PROJECT_PARENT = str(PROJECT_ROOT.parent)
ARTIFACTS_ROOT = PROJECT_ROOT / "artifacts"
REFERENCE_ROOT = PROJECT_ROOT / "references"
TEACHER_PLAN_ROOT = REFERENCE_ROOT / "teacher_plans"
DEFAULT_BENCHMARK = "JOB"
RUN_ID_PATTERN = re.compile(r"^[A-Za-z0-9._-]+$")
OFFLINE_TRAIN_EARLY_STOP_CONF_KEY = (
    "spark.sql.calibra.offlineTrain.earlyStopOnDuplicatePhysicalPlan"
)
DEFAULT_METHOD_CONF_FILES = {
    "bootstrap": "bootstrap-defaults.conf",
    "offline_train": "offline-defaults.conf",
    "online_refinement": "online-defaults.conf",
    "test": "test-defaults.conf",
}


@dataclass(frozen=True)
class BenchmarkSpec:
    benchmark: str
    database: str
    table_key: str


BENCHMARK_SPECS = {
    "JOB": BenchmarkSpec(
        benchmark="JOB",
        database="imdb_10x",
        table_key="imdb",
    ),
    "ExtJOB": BenchmarkSpec(
        benchmark="ExtJOB",
        database="imdb_10x",
        table_key="imdb",
    ),
    "TPC-H": BenchmarkSpec(
        benchmark="TPC-H",
        database="tpch_sf100",
        table_key="tpch",
    ),
    "DSB": BenchmarkSpec(
        benchmark="DSB",
        database="dsb_sf100",
        table_key="dsb",
    ),
}

BENCHMARK_ALIASES = {
    "TPCH": "TPC-H",
    "EXTJOB": "ExtJOB",
}

TABLE_DIMENSIONS = {
    "tpch": {"table_num": 8, "col_num": 16},
    "imdb": {"table_num": 17, "col_num": 34},
    "dsb": {"table_num": 24, "col_num": 0},
    "tpcds": {"table_num": 25, "col_num": 0},
}


def normalize_benchmark_name(benchmark):
    normalized = (benchmark or DEFAULT_BENCHMARK).upper()
    return BENCHMARK_ALIASES.get(normalized, normalized)


def get_benchmark_spec(benchmark):
    normalized = normalize_benchmark_name(benchmark)
    if normalized not in BENCHMARK_SPECS:
        supported = ", ".join(sorted(BENCHMARK_SPECS))
        raise ValueError(f"Unsupported benchmark: {benchmark}. Expected one of: {supported}")
    return BENCHMARK_SPECS[normalized]


def get_teacher_plan_root(kind):
    return TEACHER_PLAN_ROOT / kind.lower()


def sanitize_run_id(run_id):
    if not run_id:
        raise ValueError("run_id must be a non-empty string")
    if RUN_ID_PATTERN.fullmatch(run_id) is None:
        raise ValueError(
            "run_id may contain only letters, digits, dots, underscores, and dashes"
        )
    return run_id


def resolve_run_id(run_id=None):
    candidate = run_id or os.getenv("CALIBRA_RUN_ID") or datetime.now().strftime("%Y%m%d_%H%M%S")
    return sanitize_run_id(candidate)


@dataclass(frozen=True)
class RunArtifacts:
    benchmark: str
    run_id: str

    def __post_init__(self):
        object.__setattr__(self, "benchmark", normalize_benchmark_name(self.benchmark))
        object.__setattr__(self, "run_id", sanitize_run_id(self.run_id))

    @property
    def root_dir(self):
        return ARTIFACTS_ROOT / self.benchmark / "runs" / self.run_id

    @property
    def dataset_dir(self):
        return self.root_dir / "dataset"

    @property
    def model_dir(self):
        return self.root_dir / "model"

    @property
    def train_dir(self):
        return self.root_dir / "train"

    @property
    def eval_dir(self):
        return self.root_dir / "eval"

    @property
    def conf_dir(self):
        return self.root_dir / "conf"

    @property
    def control_dir(self):
        return self.root_dir / "control"

    @property
    def log_dir(self):
        return self.root_dir / "log"

    @property
    def raw_training_data_path(self):
        return str(self.dataset_dir / "raw_train.pt")

    @property
    def merged_training_data_path(self):
        return str(self.dataset_dir / "merged_train.pt")

    @property
    def bootstrap_data_path(self):
        return str(self.dataset_dir / "bootstrap_data.pt")

    @property
    def online_training_data_path(self):
        return str(self.dataset_dir / "online_train.pt")

    @property
    def model_path(self):
        return str(self.model_dir / "model.pt")

    @property
    def bootstrap_model_path(self):
        return str(self.model_dir / "bootstrap_model.pt")

    @property
    def online_model_path(self):
        return str(self.model_dir / "online_model.pt")

    @property
    def metrics_path(self):
        return str(self.train_dir / "metrics.csv")

    @property
    def bootstrap_metrics_path(self):
        return str(self.train_dir / "bootstrap_metrics.csv")

    @property
    def online_metrics_path(self):
        return str(self.train_dir / "online_metrics.csv")

    @property
    def pointwise_tensorboard_dir(self):
        return str(self.train_dir / "tensorboard" / "pointwise")

    @property
    def bootstrap_tensorboard_dir(self):
        return str(self.train_dir / "tensorboard" / "bootstrap")

    @property
    def latency_path(self):
        return str(self.eval_dir / "latency.json")

    @property
    def manifest_path(self):
        return str(self.root_dir / "manifest.json")

    @property
    def active_spark_submit_path(self):
        return str(self.control_dir / "active_spark_submit.json")

    @property
    def early_stop_event_path(self):
        return str(self.control_dir / "early_stop_duplicate_physical_plan.json")

    def conf_artifact_path(self, name):
        return str(self.conf_dir / name)

    def log_artifact_path(self, name):
        return str(self.log_dir / name)

    def manifest_defaults(self):
        return {
            "benchmark": self.benchmark,
            "description": "",
            "run_id": self.run_id,
            "paths": {
                "root_dir": str(self.root_dir),
                "conf_dir": str(self.conf_dir),
                "control_dir": str(self.control_dir),
                "log_dir": str(self.log_dir),
                "raw_training_data_path": self.raw_training_data_path,
                "bootstrap_data_path": self.bootstrap_data_path,
                "online_training_data_path": self.online_training_data_path,
                "model_path": self.model_path,
                "bootstrap_model_path": self.bootstrap_model_path,
                "online_model_path": self.online_model_path,
                "metrics_path": self.metrics_path,
                "bootstrap_metrics_path": self.bootstrap_metrics_path,
                "online_metrics_path": self.online_metrics_path,
                "pointwise_tensorboard_dir": self.pointwise_tensorboard_dir,
                "bootstrap_tensorboard_dir": self.bootstrap_tensorboard_dir,
                "latency_path": self.latency_path,
                "manifest_path": self.manifest_path,
                "active_spark_submit_path": self.active_spark_submit_path,
                "early_stop_event_path": self.early_stop_event_path,
            },
        }


def get_run_artifacts(benchmark=None, run_id=None):
    return RunArtifacts(
        benchmark=normalize_benchmark_name(benchmark),
        run_id=resolve_run_id(run_id),
    )


def ensure_parent_dir(path):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    return path


def ensure_dir(path):
    Path(path).mkdir(parents=True, exist_ok=True)
    return path


def write_json_atomic(path, payload):
    ensure_parent_dir(path)
    tmp_path = f"{path}.tmp.{os.getpid()}"
    with open(tmp_path, "w") as f:
        json.dump(_to_jsonable(payload), f, indent=2, sort_keys=True)
    os.replace(tmp_path, path)
    return str(path)


def read_spark_conf(path):
    conf = {}
    if not path or not os.path.exists(path):
        return conf

    with open(path, "r") as f:
        for line in f:
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue
            if "=" in stripped:
                key, value = stripped.split("=", 1)
            else:
                parts = stripped.split(None, 1)
                if len(parts) != 2:
                    continue
                key, value = parts
            conf[key.strip()] = value.strip()
    return conf


def read_spark_bool_conf(path, key, default=False):
    value = read_spark_conf(path).get(key)
    if value is None:
        return default
    return value.lower() in {"1", "true", "yes", "y", "on"}


def _to_jsonable(value):
    if isinstance(value, Path):
        return str(value)
    if isinstance(value, dict):
        return {str(key): _to_jsonable(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [_to_jsonable(item) for item in value]
    return value


def _merge_dict(target, updates):
    for key, value in updates.items():
        if isinstance(value, dict) and isinstance(target.get(key), dict):
            _merge_dict(target[key], value)
        else:
            target[key] = value


def update_manifest(manifest_path, updates):
    manifest = {}
    path = Path(manifest_path)
    if path.exists():
        with path.open("r") as f:
            manifest = json.load(f)

    normalized_updates = _to_jsonable(updates)
    if manifest.get("description") and normalized_updates.get("description") == "":
        normalized_updates.pop("description")

    _merge_dict(manifest, normalized_updates)
    ensure_parent_dir(path)
    with path.open("w") as f:
        json.dump(manifest, f, indent=2, sort_keys=True)
    return str(path)


DEFAULT_CONFIG_RUN_ID = resolve_run_id()


class TestConfig:
    def __init__(
        self,
        method,
        database,
        benchmark,
        max_retry,
        repeats,
        save_latency,
        save_path=None,
        conf_path=None,
        run_id=None,
        sqldir=None,
    ) -> None:
        self.method = method
        self.benchmark = normalize_benchmark_name(benchmark)
        self.database = database or get_benchmark_spec(self.benchmark).database
        self.timeout = 300
        self.working_dir = PROJECT_PARENT
        self.max_retry = max_retry
        self.repeats = repeats
        self.explain_only = method in {"bootstrap"}
        default_conf_name = DEFAULT_METHOD_CONF_FILES.get(method, f"{method}.conf")
        self.conf_path = conf_path or f"{PREFIX}/conf/{default_conf_name}"
        benchmark_root = (PROJECT_ROOT / "benchmark").resolve()
        if sqldir is None:
            self.benchmark_path = f"{PREFIX}/benchmark/{self.benchmark}/"
        else:
            requested_sqldir = Path(sqldir).expanduser()
            candidates = [requested_sqldir]
            if not requested_sqldir.is_absolute():
                candidates = [
                    Path.cwd() / requested_sqldir,
                    PROJECT_ROOT / requested_sqldir,
                    benchmark_root / requested_sqldir,
                ]

            resolved_sqldir = next(
                (candidate.resolve() for candidate in candidates if candidate.is_dir()),
                None,
            )
            if resolved_sqldir is None:
                raise ValueError(f"sqldir does not exist: {sqldir}")
            self.benchmark_path = str(resolved_sqldir)
        self.save_latency = save_latency
        self.artifacts = get_run_artifacts(self.benchmark, run_id)
        self.run_id = self.artifacts.run_id
        self.save_path = save_path or self.artifacts.latency_path


class TrainConfig:
    inference_only = False
    patience = None
    epochs = 300
    batch_size = 128
    current_time = DEFAULT_CONFIG_RUN_ID

    @classmethod
    def _default_artifacts(cls):
        return get_run_artifacts(
            DEFAULT_BENCHMARK,
            cls.current_time,
        )

    @classmethod
    def log_save_path(cls):
        return str(Path(cls._default_artifacts().train_dir) / "training")

    @classmethod
    def model_save_path(cls):
        return cls._default_artifacts().model_path


class EnvironmentConfig:
    database = "imdb_10x"
    table_key = "imdb"
    table_file = f"{PREFIX}/benchmark/imdb_tables.csv"
    table_num = 17
    col_num = 34

    @classmethod
    def configure(cls, database, table_key):
        dimensions = TABLE_DIMENSIONS.get(table_key)
        if dimensions is None:
            supported = ", ".join(sorted(TABLE_DIMENSIONS))
            raise ValueError(f"Unsupported table key: {table_key}. Expected one of: {supported}")

        cls.database = database
        cls.table_key = table_key
        cls.table_file = f"{PREFIX}/benchmark/{table_key}_tables.csv"
        cls.table_num = dimensions["table_num"]
        cls.col_num = dimensions.get("col_num", 0)

    @classmethod
    def configure_for_benchmark(cls, benchmark, database=None, table_key=None):
        spec = get_benchmark_spec(benchmark)
        cls.configure(database or spec.database, table_key or spec.table_key)


class LoggingConfig:
    log_level = logging.INFO
