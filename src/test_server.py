import argparse
import os

import torch
import uvicorn
from fastapi import FastAPI

from config import (
    DEFAULT_BENCHMARK,
    EnvironmentConfig,
    TrainConfig,
    get_run_artifacts,
    update_manifest,
)
from model_runtime import create_model, load_model_state, prepare_model_batch
from models.encoder import UnifiedFeatureEncoder
from preprocessor.sparkplanpreprocessor import SparkPlanPreprocessor
from request_models import CostRequest, CostResponse
from utils.logger import setup_custom_logger


MIN_PREDICTION_SECONDS = 1.0


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--benchmark")
    parser.add_argument("--database")
    parser.add_argument("--table-key")
    parser.add_argument("--model-path")
    parser.add_argument("--run-id")
    parser.add_argument("--port", type=int, default=10533)
    return parser.parse_args()


args = parse_args()
logger = setup_custom_logger("SERVER")
selected_benchmark = args.benchmark or DEFAULT_BENCHMARK
artifacts = get_run_artifacts(benchmark=selected_benchmark, run_id=args.run_id)
TrainConfig.current_time = artifacts.run_id
EnvironmentConfig.configure_for_benchmark(
    selected_benchmark,
    database=args.database,
    table_key=args.table_key,
)

if args.model_path:
    model_path = args.model_path
elif args.run_id or os.getenv("CALIBRA_RUN_ID"):
    model_path = artifacts.model_path
else:
    raise ValueError(
        "test_server requires --model-path or --run-id for a trained Calibra run; "
        "this release does not include pretrained model defaults."
    )

preprocessor = SparkPlanPreprocessor()
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
encoder = UnifiedFeatureEncoder()
model = create_model(in_features=encoder.in_features).to(device)
load_model_state(model, model_path, device)
model.eval()

app = FastAPI()
logger.info("Loaded model from %s", model_path)
logger.info(
    "Runtime environment: benchmark=%s database=%s table_key=%s in_features=%s",
    selected_benchmark,
    EnvironmentConfig.database,
    EnvironmentConfig.table_key,
    encoder.in_features,
)

update_manifest(
    artifacts.manifest_path,
    {
        **artifacts.manifest_defaults(),
        "server": {
            "benchmark": selected_benchmark,
            "database": EnvironmentConfig.database,
            "table_key": EnvironmentConfig.table_key,
            "run_id": artifacts.run_id,
            "model_path": model_path,
            "port": args.port,
            "log_path": getattr(logger, "log_path", artifacts.log_artifact_path("test_server.log")),
        },
    },
)


def floor_costs(costs):
    return [max(float(cost), MIN_PREDICTION_SECONDS) for cost in costs]


def predict_costs(encoded_trees):
    pred = model(prepare_model_batch(encoded_trees))
    return floor_costs(pred.squeeze(dim=1).tolist())


@app.post("/cost")
async def receive_plan(request: CostRequest):
    if not request.candidates:
        return CostResponse(costs=[])

    try:
        trees = [preprocessor.plan2tree(plan_info) for plan_info in request.candidates]
        encoded_trees = [encoder.featurize(tree) for tree in trees]
    except Exception:
        fallback_costs = [MIN_PREDICTION_SECONDS] * len(request.candidates)
        logger.exception(
            "Failed to featurize cost request type=%s candidates=%s; returning equal fallback costs=%s",
            request.type,
            len(request.candidates),
            fallback_costs,
        )
        return CostResponse(costs=fallback_costs)

    with torch.no_grad():
        costs = predict_costs(encoded_trees)
        if request.type == 0:
            logger.info("Logical Cost: %s", costs)
        elif request.type == 1:
            logger.info("Physical Cost: %s", costs)
        elif request.type == 2:
            logger.info("AQE Cost: %s", costs)
    return CostResponse(costs=costs)


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=args.port)
