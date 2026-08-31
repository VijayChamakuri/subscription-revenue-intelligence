"""Validate the Hive-compatible external table against Spark Parquet output."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from pyspark.sql import SparkSession


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ddl", type=Path, required=True)
    parser.add_argument("--parquet", type=Path, required=True)
    parser.add_argument("--expected-events", type=int, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    parquet_path = args.parquet.resolve()
    spark = (
        SparkSession.builder.appName("validate-hive-product-usage")
        .master("local[*]")
        .enableHiveSupport()
        .getOrCreate()
    )
    spark.sparkContext.setLogLevel("WARN")

    statements = [
        statement.strip()
        for statement in args.ddl.read_text().replace(
            "${PRODUCT_USAGE_DAILY_PATH}", str(parquet_path)
        ).split(";")
        if statement.strip()
    ]
    spark.sql("create database if not exists analytics")
    spark.sql("drop table if exists analytics.fact_product_usage_daily")
    for statement in statements:
        spark.sql(statement)

    frame = spark.table("analytics.fact_product_usage_daily")
    daily_rows = frame.count()
    event_total = frame.agg({"event_count": "sum"}).first()[0]
    partitions = len(spark.sql("show partitions analytics.fact_product_usage_daily").collect())
    if event_total != args.expected_events:
        raise ValueError(
            f"Hive table event total {event_total} does not equal {args.expected_events}"
        )
    if partitions == 0 or daily_rows == 0:
        raise ValueError("Hive table must expose nonempty partitions and daily rows")

    result = {
        "status": "passed",
        "daily_rows": daily_rows,
        "event_total": event_total,
        "partitions": partitions,
        "parquet_path": str(parquet_path),
        "spark_version": spark.version,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2))
    print(json.dumps(result, indent=2))
    spark.sql("drop table analytics.fact_product_usage_daily")
    spark.stop()


if __name__ == "__main__":
    main()
