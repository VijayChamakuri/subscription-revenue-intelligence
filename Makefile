.PHONY: setup generate validate load dbt spark analytics test pipeline clean

setup:
	uv sync --extra dev

generate:
	uv run python -m src.generation.generate --config config/project.yml

validate:
	uv run python -m src.validation.validate_sources --data-dir data/raw

load:
	uv run python -m src.ingestion.load_duckdb --data-dir data/raw --database data/warehouse/subscription.duckdb

dbt:
	cd dbt && ../.venv/bin/dbt build --profiles-dir .

spark:
	uv run --extra spark spark-submit spark/process_usage_events.py --input data/raw/product_usage_events.csv --output data/processed/product_usage_daily

analytics:
	uv run python -m src.analytics.export_bi
	uv run python -m src.modeling.churn --input-csv data/raw/model_churn_snapshots.csv --output-dir artifacts/modeling
	uv run python -m src.modeling.forecast --input-csv data/exports/forecast_input.csv --output-dir artifacts/forecast
	uv run python -m src.validation.publish_results

test:
	uv run ruff check src tests spark airflow
	uv run pytest

pipeline: generate validate load dbt analytics test

clean:
	uv run python scripts/clean_generated.py
