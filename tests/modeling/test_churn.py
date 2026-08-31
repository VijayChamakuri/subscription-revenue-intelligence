import numpy as np
import pandas as pd
import pytest

from src.modeling.churn import (
    InterventionEconomics,
    SplitDates,
    choose_business_threshold,
    run_churn_experiment,
    synthetic_churn_fixture,
    temporal_split,
)


def test_temporal_split_has_no_overlap():
    train, calibration, test = temporal_split(
        synthetic_churn_fixture(accounts=2200), SplitDates("2024-06-30", "2024-12-31")
    )
    assert train["as_of_date"].max() < calibration["as_of_date"].min()
    assert calibration["as_of_date"].max() < test["as_of_date"].min()


def test_threshold_maximizes_stated_expected_value():
    economics = InterventionEconomics(
        contact_cost=10, retained_margin_if_successful=100, intervention_success_rate=0.5
    )
    threshold, table = choose_business_threshold([1, 0, 1, 0], [0.9, 0.8, 0.7, 0.1], economics)
    selected = table.loc[np.isclose(table["threshold"], threshold)].iloc[0]
    assert selected["expected_net_value"] == table["expected_net_value"].max()


def test_experiment_reports_future_metrics_and_scores():
    results, scores = run_churn_experiment(
        synthetic_churn_fixture(accounts=2200), SplitDates("2024-06-30", "2024-12-31")
    )
    assert {"logistic_regression", "hist_gradient_boosting"}.issubset(results)
    for model in ("logistic_regression", "hist_gradient_boosting"):
        assert 0 <= results[model]["roc_auc"] <= 1
        assert 0 <= results[model]["brier_score"] <= 1
        assert scores[f"{model}_risk"].between(0, 1).all()


def test_duplicate_snapshot_is_rejected():
    data = synthetic_churn_fixture(accounts=100)
    duplicate = pd.concat([data, data.iloc[[0]]], ignore_index=True)
    with pytest.raises(ValueError, match="Duplicate account"):
        temporal_split(duplicate, SplitDates("2024-06-30", "2024-12-31"))
