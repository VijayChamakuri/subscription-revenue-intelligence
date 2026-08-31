# Executive Summary

## Decision summary

This platform analyzes a deterministic synthetic B2B SaaS dataset to explain recurring-revenue movement, expose finance reconciliation exceptions, prioritize churn review, and compare growth efficiency. Findings are simulation evidence only. They do not represent real company outcomes.

## Verified operating context

- Run identifier: seed `20260831`, configuration SHA-256 `3dca59977a0ff9ea459eb1c6385e488e216f84ac2027fe163eaa061e00b155b3`
- Observation window: January 2023 through December 2025
- Customer accounts: 1,200
- Total source and modeling records: 695,036
- Product events: 600,000 rows, 33,944,800 CSV bytes
- Reporting currency: USD presentation, synthetic local-currency codes preserved without claiming audited FX treatment
- dbt status: 36 models, 71 data tests, 104 total resources passed

## Evidence-backed findings

1. December 2025 closes at $2.282 million synthetic MRR and $27.387 million synthetic ARR. Net new MRR is negative $123,992, GRR is 91.87%, and NRR is 92.98%.
2. The MRR movement bridge reconciles to a maximum absolute difference of $0.00 across 36 months.
3. Finance rules detect 963 contract-date conflicts and quantify $1,400,498.67 of failed-payment exposure across 575 synthetic attempts.
4. The calibrated logistic model reaches 0.710 ROC-AUC, 0.058 PR-AUC, and 0.014 Brier score on an unseen future holdout after adding behavior noise, missingness, temporal drift, and label noise.

## Prioritized recommendations

1. **Contract controls:** Correct the lifecycle rules that create 963 date conflicts. Focus first on canceled and annual subscriptions. Difficulty is medium because source-state and effective-date ownership must be clarified. Monitor exception count and aging.
2. **Payment recovery:** Create an operational queue for 575 failed attempts representing $1.400 million of synthetic exposure. Difficulty is low to medium. Monitor recovery rate, recovered cash, and days outstanding.
3. **Retention triage:** Pilot a tightly capacity-controlled review rather than contacting every low-threshold account. Modeled economics assume a $35 contact cost, $6,000 retained margin if successful, and 18% success probability. Difficulty is medium. Monitor precision, incremental renewal through a controlled experiment, and calibration drift.
4. **Closing-month churn review:** Investigate the synthetic December cohort behind negative net new MRR and 91.87% GRR. Difficulty is medium. Monitor churned MRR, contraction MRR, and NRR by segment and plan.
5. **Metric governance:** Adopt the dbt metric and test layer as the approval path for executive totals. Difficulty is low. Monitor failed tests, reconciliation differences, freshness, and BI-to-warehouse variances.

These are recommendations for a fictional company. Estimated opportunities are projections under stated assumptions, not realized revenue or savings.
