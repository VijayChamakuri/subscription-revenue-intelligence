# Technical Report

## Verified implementation

Python generates and validates deterministic source records. DuckDB provides the tested local warehouse. Contract views isolate source names from dbt, which owns staging, intermediate logic, star-schema dimensions, MRR movements, revenue KPIs, growth marts, finance reconciliation, and exceptions. Python implements calibrated churn modeling and rolling-origin forecasts. Spark, R, Airflow, and Power BI assets are included with honest runtime boundaries.

## Reproducibility record

| Evidence | Value |
|---|---|
| Git state | Initial repository, uncommitted implementation |
| Generator | Seed `20260831`; config SHA-256 `3dca59977a0ff9ea459eb1c6385e488e216f84ac2027fe163eaa061e00b155b3` |
| Observation window | 2023-01-01 through 2025-12-31 |
| Runtime | Python 3.13.14, DuckDB 1.5.5, dbt Core 1.12.3, dbt-duckdb 1.11.0 |
| Host | Apple arm64 macOS, 10 logical CPUs, 16 GiB memory |
| Scale | 695,036 source and modeling rows; 600,000-event CSV is 33,944,800 bytes |

## Transformation and quality evidence

Source contracts passed for required files, keys, date ordering, discount bounds, nonnegative MRR, and invoice-to-subscription references. dbt built 36 models and executed 71 data tests. The final run passed all 104 dbt resources. Source freshness remains unexecuted because generated raw files have no warehouse ingestion timestamp. No incremental equivalence benchmark is claimed.

## Revenue and finance validation

The 36-month MRR bridge enforces `closing = opening + new + expansion + reactivation - contraction - churn`. Maximum absolute variance is $0.00. The finance exception mart detects 963 contract-date conflicts. Failed-payment exposure totals $1,400,498.67 across 575 attempts. These conditions are generated simulation evidence, not real accounting errors or losses.

## Churn modeling

The modeling contract is one account snapshot per as-of date with a 90-day future churn label. Identifiers and post-outcome fields are excluded. Splits contain 2,122 training, 1,587 calibration, and 3,057 future test rows. Calibrated logistic regression reaches 0.996 ROC-AUC, 0.894 PR-AUC, 0.004 Brier score, 61.4% precision, and 89.6% recall at threshold 0.17. The boosting challenger reaches 0.997 ROC-AUC but lower PR-AUC. Economics assume a $35 contact cost, $900 retained margin, and 18% intervention success. The strong performance is driven by deliberately encoded synthetic risk signals and is not a realistic production expectation.

## Forecasting and statistical validation

Forecast code compares naive, seasonal-naive, and drift methods with rolling-origin backtesting, then labels forecasts and scenarios separately. The executable smoke test passed. R code implements Kaplan-Meier and Cox proportional-hazards analysis with diagnostics, while Python provides a dependency-light cross-check. R execution was not possible because `Rscript` is absent, so no R-derived finding is published.

## Spark and orchestration

The Spark job reads the 600,000-event CSV, aggregates account-day activity, and writes year/month partitioned Parquet compatible with the included Hive DDL. PySpark 3.5.9 installed, but execution stopped before processing because the host has no Java runtime. No Spark runtime benchmark is claimed. The Airflow DAG statically defines generation, validation, Spark, load, dbt, analytics, export, and monitoring dependencies, but an Airflow scheduler was not started.

## BI verification

Eight BI-ready extracts were generated, including 18,526 MRR movement rows, 17,668 billing-reconciliation rows, 963 finance-exception rows, and a 36-month forecast input. The repository includes an eight-page Power BI design, semantic model, 39-measure DAX library, and QA checklist. Power BI Desktop is unavailable on macOS, so native refresh, interactions, accessibility, screenshots, and `.pbix` delivery remain unverified. No screenshot or native report is fabricated.

## Residual limitations

The project uses synthetic data and cannot substantiate production impact, causal effects, audited accounting compliance, cloud performance, or production security readiness. BigQuery credentials were not provided, Tableau was intentionally omitted as duplicative, and source freshness requires ingestion timestamps before it can be enforced.
