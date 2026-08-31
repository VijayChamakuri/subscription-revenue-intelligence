from pathlib import Path

import pandas as pd

from src.generation.generate import generate
from src.validation.validate_sources import validate


def _config(path: Path, seed: int = 7) -> Path:
    path.write_text(
        f"seed: {seed}\nstart_date: '2024-01-01'\nend_date: '2024-12-31'\naccounts: 25\nusage_events: 200\nbase_currency: USD\ncurrencies: {{USD: 1.0}}\n"
    )
    return path


def test_generation_is_reproducible_and_valid(tmp_path: Path) -> None:
    cfg = _config(tmp_path / "config.yml")
    one, two = tmp_path / "one", tmp_path / "two"
    assert generate(cfg, one) == generate(cfg, two)
    assert (one / "generation_manifest.json").read_text() == (
        two / "generation_manifest.json"
    ).read_text()
    assert validate(one)["status"] == "passed"
    pd.testing.assert_frame_equal(
        pd.read_csv(one / "fact_subscriptions.csv"), pd.read_csv(two / "fact_subscriptions.csv")
    )


def test_synthetic_rules(tmp_path: Path) -> None:
    raw = tmp_path / "raw"
    generate(_config(tmp_path / "config.yml", 9), raw)
    subs = pd.read_csv(raw / "fact_subscriptions.csv")
    assert subs.discount_rate.between(0, 0.5).all()
    assert (subs.initial_mrr >= 0).all()
    assert subs.subscription_id.is_unique
    payments = pd.read_csv(raw / "fact_payments.csv")
    failed = payments[payments.status == "failed"]
    assert not failed.empty
    assert (failed.amount > 0).all()
    snapshots = pd.read_csv(raw / "model_churn_snapshots.csv")
    assert snapshots.churned_within_90d.isin([0, 1]).all()
