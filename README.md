# Calibra

Calibra combines a Python Spark SQL cost-modeling pipeline with Spark-side Scala integration for Spark 3.5.4. Python training and serving code lives in `src/`, Spark runtime support lives in `RuntimeCost/`, and Spark source changes are maintained as patch material under `spark_patches/`.

## Artifact Layout

Run outputs belong under `artifacts/<BENCHMARK>/runs/<RUN_ID>/`. The runtime writes datasets, models, metrics, logs, Spark configuration copies, latency files, and manifests under that run directory.

## Spark Patch Workflow

The Spark patch in this release is the source of truth:

```text
spark_patches/calibra-spark-3.5.4.patch
```

From a clean Spark 3.5.4 source tree:

```bash
export CALIBRA_ROOT=/path/to/Calibra_release
git apply --check --whitespace=error "$CALIBRA_ROOT/spark_patches/calibra-spark-3.5.4.patch"
git apply "$CALIBRA_ROOT/spark_patches/calibra-spark-3.5.4.patch"
./build/sbt "catalyst/package" "sql/package"
```

Then replace the Spark SQL and Catalyst jars in the active Spark runtime:

```bash
export SPARK_HOME=/path/to/spark-3.5.4-bin-hadoop3
cp sql/catalyst/target/scala-2.12/spark-catalyst_2.12-3.5.4.jar "$SPARK_HOME/jars/"
cp sql/core/target/scala-2.12/spark-sql_2.12-3.5.4.jar "$SPARK_HOME/jars/"
```

The patched runtime must also have the Calibra Spark patch dependencies on the Spark classpath, including `sttp client4` and `upickle`. If only replacing module jars, ensure those dependency jars are present in `$SPARK_HOME/jars/`; a full Spark distribution build from the patched source avoids missing runtime dependencies.

Restart Spark services after replacing jars.

## Running Calibra

Run Calibra phases directly through Python entrypoints. The Spark property files in `conf/` are templates; replace Spark master, local directory, warehouse, event log, and RuntimeCost jar placeholders before use.

Bootstrap, training, testing, and online refinement can be run from scratch for a chosen `<RUN_ID>`. The serving entrypoints load the checkpoint produced under `artifacts/<BENCHMARK>/runs/<RUN_ID>/model/` unless `--model-path` is explicitly provided.

The bootstrap server uses CBO teacher-plan files by default:

```bash
python src/bootstrap_server.py --benchmark JOB --run-id <RUN_ID> --port 10533
python src/test.py --method bootstrap --database imdb_10x --benchmark JOB --run-id <RUN_ID> --conf-path conf/bootstrap-defaults.conf
python src/bootstrap.py --benchmark JOB --run-id <RUN_ID>
```

Train a Calibra Tree LRU model from collected data:

```bash
python src/train.py --benchmark JOB --run-id <RUN_ID> --data-path artifacts/JOB/runs/<RUN_ID>/dataset/bootstrap_data.pt
```

Serve and evaluate the trained model for the same run:

```bash
python src/test_server.py --benchmark JOB --run-id <RUN_ID> --port 10533
python src/test.py --method test --database imdb_10x --benchmark JOB --run-id <RUN_ID> --conf-path conf/test-defaults.conf
```
