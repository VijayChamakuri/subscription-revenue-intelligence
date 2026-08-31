.PHONY: setup generate validate load dbt-deps dbt spark spark-validate survival analytics test pipeline pipeline-full airflow-test clean

setup:
	uv sync --extra dev

generate:
	uv run python -m src.generation.generate --config config/project.yml

validate:
	uv run python -m src.validation.validate_sources --data-dir data/raw

load:
	uv run python -m src.ingestion.load_duckdb --data-dir data/raw --database data/warehouse/subscription.duckdb

dbt-deps:
	cd dbt && ../.venv/bin/dbt deps --profiles-dir .

dbt: dbt-deps
	cd dbt && ../.venv/bin/dbt build --profiles-dir .

spark:
	uv run --extra spark spark-submit spark/process_usage_events.py --input data/raw/product_usage_events.csv --output data/processed/product_usage_daily

spark-validate:
	uv run --extra spark spark-submit spark/validate_hive_table.py --parquet data/processed/product_usage_daily --ddl hive/product_usage_daily.sql --expected-events 600000 --output artifacts/hive_validation.json

survival:
	uv run python -m src.analytics.export_survival_input
	Rscript r/survival_analysis.R data/exports/survival_input.csv artifacts/r_survival
	uv run python -m src.analytics.validate_survival_outputs --input data/exports/survival_input.csv --r-output artifacts/r_survival/kaplan_meier_by_plan.csv --output artifacts/r_survival_validation.json

analytics:
	uv run python -m src.analytics.export_bi
	uv run python -m src.modeling.churn --input-csv data/raw/model_churn_snapshots.csv --output-dir artifacts/modeling
	uv run python -m src.modeling.forecast --input-csv data/exports/forecast_input.csv --output-dir artifacts/forecast
	uv run python -m src.validation.publish_results

test:
	uv run ruff check src tests spark airflow
	uv run pytest

pipeline: generate validate load dbt analytics test

pipeline-full: pipeline spark spark-validate survival

airflow-test:
	uv run --extra airflow airflow dags test subscription_revenue_intelligence 2025-01-02 --subdir airflow/dags/subscription_intelligence.py

clean:
	uv run python scripts/clean_generated.py
