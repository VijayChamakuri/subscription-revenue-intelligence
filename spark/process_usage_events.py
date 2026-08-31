from __future__ import annotations

import argparse
import json
import platform
import time
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql import functions as F


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--benchmark", default="artifacts/spark_benchmark.json")
    args = parser.parse_args()
    started = time.perf_counter()
    spark = (
        SparkSession.builder.appName("subscription-usage-processing")
        .master("local[*]")
        .getOrCreate()
    )
    frame = spark.read.option("header", True).option("inferSchema", True).csv(args.input)
    clean = (
        frame.withColumn("event_timestamp", F.to_timestamp("event_timestamp"))
        .withColumn("event_date", F.to_date("event_timestamp"))
        .withColumn("event_year", F.year("event_timestamp"))
        .withColumn("event_month", F.month("event_timestamp"))
        .filter(F.col("account_id").isNotNull() & F.col("event_timestamp").isNotNull())
    )
    rows = clean.count()
    daily = clean.groupBy("event_year", "event_month", "event_date", "account_id").agg(
        F.count("*").alias("event_count"),
        F.countDistinct("feature").alias("features_adopted"),
        F.sum("session_minutes").alias("session_minutes"),
        F.max("event_timestamp").alias("last_activity_at"),
    )
    daily.write.mode("overwrite").partitionBy("event_year", "event_month").parquet(args.output)
    result = {
        "input_rows": rows,
        "elapsed_seconds": round(time.perf_counter() - started, 3),
        "spark_version": spark.version,
        "python_version": platform.python_version(),
        "execution_mode": "local[*]",
        "input_bytes": Path(args.input).stat().st_size,
    }
    path = Path(args.benchmark)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(result, indent=2))
    print(json.dumps(result, indent=2))
    spark.stop()


if __name__ == "__main__":
    main()
