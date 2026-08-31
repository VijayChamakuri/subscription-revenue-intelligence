import pandas as pd
import pytest

from src.modeling.forecast import (
    Scenario,
    apply_scenario,
    forecast_best_method,
    rolling_backtest,
    summarize_backtest,
    synthetic_monthly_fixture,
)


def test_backtest_uses_only_prior_observations_and_all_methods():
    data = synthetic_monthly_fixture()
    result = rolling_backtest(data, horizon=3, min_train=18)
    assert set(result["method"]) == {"naive", "seasonal_naive", "drift"}
    assert (result["cutoff_month"] < data["month"].max()).all()
    assert (result["forecast"] >= 0).all()
    assert summarize_backtest(result)["observations"].min() > 0


def test_best_method_forecasts_future_months():
    data = synthetic_monthly_fixture()
    forecast, summary = forecast_best_method(data, "mrr", horizon=6)
    assert len(forecast) == 6
    assert forecast["month"].min() > data["month"].max()
    assert forecast["method"].nunique() == 1
    assert forecast["method"].iloc[0] == summary["method"].iloc[0]


def test_scenario_math_is_explicit_and_baseline_unchanged():
    data = synthetic_monthly_fixture(periods=24)
    baseline = apply_scenario(data, Scenario("baseline"))
    assert baseline["scenario_mrr"].equals(baseline["mrr"])
    scenario = apply_scenario(
        data, Scenario("recovery", churn_change_pct=-0.1, failed_payment_recovery_pct=0.2)
    )
    expected = data["churned_mrr"] * 0.1
    pd.testing.assert_series_equal(
        scenario["incremental_mrr_estimate"], expected, check_names=False
    )


def test_duplicate_month_rejected():
    data = synthetic_monthly_fixture(periods=24)
    with pytest.raises(ValueError, match="duplicate months"):
        rolling_backtest(pd.concat([data, data.iloc[[0]]], ignore_index=True))
