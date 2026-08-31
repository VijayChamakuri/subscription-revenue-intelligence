import json
from pathlib import Path

import pandas as pd
import pytest

from src.generation.generate import generate
from src.validation.validate_sources import SCHEMAS, validate


def _generated(tmp_path: Path, usage_events: int = 200) -> Path:
    config = tmp_path / "config.yml"
    config.write_text(
        "seed: 19\nstart_date: '2024-01-01'\nend_date: '2024-12-31'\n"
        f"accounts: 25\nusage_events: {usage_events}\nbase_currency: USD\n"
        "currencies: {USD: 1.0}\n"
    )
    raw = tmp_path / "raw"
    generate(config, raw)
    return raw


def _failure(raw: Path) -> dict[str, object]:
    with pytest.raises(ValueError) as exc_info:
        validate(raw)
    return json.loads(str(exc_info.value))


def test_all_generated_sources_are_contract_checked(tmp_path: Path) -> None:
    result = validate(_generated(tmp_path))
    assert result == {"status": "passed", "errors": [], "tables_checked": len(SCHEMAS)}


def test_missing_column_and_invalid_range_are_detected(tmp_path: Path) -> None:
    raw = _generated(tmp_path)
    health_path = raw / "fact_customer_health.csv"
    health = pd.read_csv(health_path).drop(columns=["snapshot_date"])
    health.loc[0, "feature_adoption_rate"] = 1.5
    health.to_csv(health_path, index=False)

    errors = _failure(raw)["errors"]
    assert "fact_customer_health missing columns: ['snapshot_date']" in errors
    assert "fact_customer_health.feature_adoption_rate outside [0, 1]" in errors


def test_cross_table_relationship_and_date_order_are_detected(tmp_path: Path) -> None:
    raw = _generated(tmp_path)
    contracts_path = raw / "fact_contracts.csv"
    contracts = pd.read_csv(contracts_path)
    contracts.loc[0, "account_id"] = "UNKNOWN"
    contracts.loc[0, "end_date"] = "2020-01-01"
    contracts.to_csv(contracts_path, index=False)

    errors = _failure(raw)["errors"]
    assert "fact_contracts.account_id references 1 unknown dim_account keys" in errors
    assert "fact_contracts.end_date precedes start_date" in errors


def test_usage_validation_detects_duplicate_across_chunks_and_unknown_account(
    tmp_path: Path,
) -> None:
    raw = _generated(tmp_path, usage_events=100_001)
    usage_path = raw / "product_usage_events.csv"
    usage = pd.read_csv(usage_path)
    usage.loc[100_000, "usage_event_id"] = usage.loc[0, "usage_event_id"]
    usage.loc[100_000, "account_id"] = "UNKNOWN"
    usage.to_csv(usage_path, index=False)

    errors = _failure(raw)["errors"]
    assert "product_usage_events.usage_event_id must be unique and non-null" in errors
    assert "product_usage_events.account_id references 1 unknown dim_account keys" in errors
