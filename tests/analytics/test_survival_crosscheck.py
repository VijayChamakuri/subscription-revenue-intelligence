import pandas as pd

from src.analytics.survival_crosscheck import grouped_kaplan_meier, kaplan_meier


def test_kaplan_meier_known_example():
    data = pd.DataFrame({"tenure_months": [1, 2, 2, 3], "churned": [1, 1, 0, 1]})
    result = kaplan_meier(data)
    assert result["survival_probability"].round(6).tolist() == [0.75, 0.5, 0.0]
    assert result["at_risk"].tolist() == [4, 3, 1]


def test_grouped_survival_keeps_strata():
    data = pd.DataFrame(
        {
            "tenure_months": [1, 2, 1, 3],
            "churned": [1, 0, 0, 1],
            "plan_type": ["monthly", "monthly", "annual", "annual"],
        }
    )
    result = grouped_kaplan_meier(data, "plan_type")
    assert set(result["plan_type"]) == {"monthly", "annual"}
