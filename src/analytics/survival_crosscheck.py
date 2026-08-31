"""Dependency-light Kaplan-Meier estimates used to cross-check the R analysis."""

from __future__ import annotations

import pandas as pd


def kaplan_meier(
    frame: pd.DataFrame, duration: str = "tenure_months", event: str = "churned"
) -> pd.DataFrame:
    if frame.empty:
        raise ValueError("Survival input cannot be empty")
    if (frame[duration] < 0).any() or not frame[event].isin([0, 1, False, True]).all():
        raise ValueError("Survival duration must be nonnegative and event must be binary")
    times = sorted(frame.loc[frame[event].astype(bool), duration].unique())
    survival = 1.0
    rows = []
    for time in times:
        at_risk = int((frame[duration] >= time).sum())
        events = int(((frame[duration] == time) & frame[event].astype(bool)).sum())
        survival *= 1 - events / at_risk
        rows.append(
            {
                "time": float(time),
                "at_risk": at_risk,
                "events": events,
                "survival_probability": survival,
            }
        )
    return pd.DataFrame(rows)


def grouped_kaplan_meier(frame: pd.DataFrame, group: str) -> pd.DataFrame:
    results = []
    for value, partition in frame.groupby(group, dropna=False):
        estimate = kaplan_meier(partition)
        estimate[group] = value
        results.append(estimate)
    return pd.concat(results, ignore_index=True) if results else pd.DataFrame()
