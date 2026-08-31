"""Cross-check R Kaplan-Meier estimates against the Python implementation."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import pandas as pd

from src.analytics.survival_crosscheck import grouped_kaplan_meier


def validate(input_csv: Path, r_output: Path, tolerance: float = 1e-10) -> dict[str, object]:
    spells = pd.read_csv(input_csv)
    python = grouped_kaplan_meier(spells, "plan_type").rename(
        columns={"survival_probability": "python_survival"}
    )
    r_frame = pd.read_csv(r_output).rename(
        columns={"survival_probability": "r_survival"}
    )
    r_frame["plan_type"] = r_frame["stratum"].str.replace("plan_type=", "", regex=False)
    compared = python.merge(r_frame, on=["plan_type", "time"], how="inner")
    if compared.empty:
        raise ValueError("R and Python survival outputs have no comparable estimates")
    maximum_difference = float(
        (compared.python_survival - compared.r_survival).abs().max()
    )
    if maximum_difference > tolerance:
        raise ValueError(
            f"R and Python Kaplan-Meier difference {maximum_difference} exceeds {tolerance}"
        )
    return {
        "status": "passed",
        "rows_compared": len(compared),
        "maximum_survival_difference": maximum_difference,
        "tolerance": tolerance,
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--r-output", type=Path, required=True)
    parser.add_argument(
        "--output", type=Path, default=Path("artifacts/r_survival_validation.json")
    )
    args = parser.parse_args()
    result = validate(args.input, args.r_output)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2))
    print(json.dumps(result, indent=2))
