"""Airflow DAG for the reproducible local analytics pipeline."""

from __future__ import annotations

from datetime import datetime
from pathlib import Path

try:
    from airflow.operators.bash import BashOperator

    from airflow import DAG
except ImportError:
    DAG = None

ROOT = Path(__file__).resolve().parents[2]

if DAG is not None:
    with DAG(
        dag_id="subscription_revenue_intelligence",
        start_date=datetime(2025, 1, 1),
        schedule=None,
        catchup=False,
        tags=["portfolio", "synthetic", "revenue"],
    ) as dag:
        generate = BashOperator(
            task_id="generate_sources", bash_command=f"cd '{ROOT}' && make generate"
        )
        validate = BashOperator(
            task_id="validate_contracts", bash_command=f"cd '{ROOT}' && make validate"
        )
        spark = BashOperator(
            task_id="process_usage_spark", bash_command=f"cd '{ROOT}' && make spark"
        )
        load = BashOperator(task_id="load_duckdb", bash_command=f"cd '{ROOT}' && make load")
        dbt = BashOperator(task_id="build_dbt", bash_command=f"cd '{ROOT}' && make dbt")
        analytics = BashOperator(
            task_id="run_analytics", bash_command=f"cd '{ROOT}' && make analytics"
        )
        export = BashOperator(
            task_id="export_dashboard_data",
            bash_command=f"cd '{ROOT}' && uv run python -m src.analytics.export_bi",
        )
        monitor = BashOperator(
            task_id="publish_monitoring",
            bash_command=f"cd '{ROOT}' && uv run python -m src.validation.publish_results",
        )
        generate >> validate >> spark >> load >> dbt >> analytics >> export >> monitor
