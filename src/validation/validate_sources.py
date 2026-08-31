from __future__ import annotations

import argparse
import json
from pathlib import Path

import pandas as pd

REQUIRED = {
    "dim_account": ["account_id", "segment", "geography_id"],
    "fact_subscriptions": [
        "subscription_id",
        "account_id",
        "start_date",
        "status",
        "discount_rate",
        "initial_mrr",
    ],
    "fact_invoices": ["invoice_id", "subscription_id", "amount", "currency"],
    "fact_payments": ["payment_id", "invoice_id", "amount", "status"],
    "fact_subscription_events": [
        "subscription_event_id",
        "subscription_id",
        "event_type",
        "mrr_before",
        "mrr_after",
    ],
}


def validate(data_dir: Path) -> dict[str, object]:
    errors: list[str] = []
    frames: dict[str, pd.DataFrame] = {}
    for table, cols in REQUIRED.items():
        path = data_dir / f"{table}.csv"
        if not path.exists():
            errors.append(f"missing source: {path}")
            continue
        frames[table] = pd.read_csv(path)
        missing = sorted(set(cols) - set(frames[table].columns))
        if missing:
            errors.append(f"{table} missing columns: {missing}")
        for key in [c for c in cols if c.endswith("_id") and c == cols[0]]:
            if frames[table][key].isna().any() or frames[table][key].duplicated().any():
                errors.append(f"{table}.{key} must be unique and non-null")
    if "fact_subscriptions" in frames:
        subs = frames["fact_subscriptions"]
        if (~subs.discount_rate.between(0, 0.5)).any():
            errors.append("discount_rate outside [0, 0.5]")
        if (subs.initial_mrr < 0).any():
            errors.append("negative subscription MRR")
        dated = subs.dropna(subset=["end_date", "start_date"])
        if (pd.to_datetime(dated.end_date) < pd.to_datetime(dated.start_date)).any():
            errors.append("subscription end precedes start")
    if {"fact_invoices", "fact_subscriptions"} <= frames.keys():
        unknown = set(frames["fact_invoices"].subscription_id) - set(
            frames["fact_subscriptions"].subscription_id
        )
        if unknown:
            errors.append(f"invoices reference {len(unknown)} unknown subscriptions")
    result = {
        "status": "failed" if errors else "passed",
        "errors": errors,
        "tables_checked": len(frames),
    }
    if errors:
        raise ValueError(json.dumps(result, indent=2))
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data-dir", type=Path, default=Path("data/raw"))
    args = parser.parse_args()
    print(json.dumps(validate(args.data_dir), indent=2))
