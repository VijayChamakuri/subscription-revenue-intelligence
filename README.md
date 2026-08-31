# Subscription Revenue and Customer Growth Intelligence Platform

A reproducible analytics product for a fictional B2B SaaS company that connects subscription movements, billing, collections, revenue recognition, customer health, acquisition efficiency, and churn risk. Every record and finding in this repository is synthetic. No production impact is claimed.

## Decisions supported

Finance can trace MRR to invoices, cash, refunds, and recognized revenue. Revenue Operations can explain new, expansion, contraction, churn, and reactivation MRR. Marketing and Customer Success can compare acquisition quality, unit economics, adoption, and risk. Executives receive one tested metric layer rather than competing spreadsheet definitions.

## Verified project evidence

The deterministic seed `20260831` generates 695,036 source and modeling records, including 600,000 product-usage events, 17,668 invoices, 17,668 payments, 6,766 time-stamped churn snapshots, 3,600 support tickets, and 1,200 accounts. The latest verified synthetic month closes at $2,282,230.53 MRR and $27,386,766.36 ARR. The monthly MRR bridge has a maximum reconciliation difference of $0.00.

The finance exception mart detects 963 contract-date conflicts, while failed-payment exposure totals $1,400,498.67 across 575 attempts in the synthetic dataset. These are detected data-quality and collection conditions, not real company losses. The project-integrated churn snapshots produce 0.996 ROC-AUC, 0.894 PR-AUC, and 0.004 Brier score for calibrated logistic regression. The unusually strong synthetic result reflects deliberately encoded risk signals and should not be expected with real data. Model results do not demonstrate a real retention intervention.

## Architecture

```text
Deterministic Python generator -> source contracts -> Spark event aggregation
             |                                      |
             +-> DuckDB raw contract views -> dbt staging/intermediate/marts
                                                   |
                         finance + growth + revenue + BI exports
                                                   |
                         Python models + R validation + Power BI spec
```

SQL and dbt own business transformations and trusted metrics. Python owns generation, validation, loading, forecasting, modeling, and automation helpers. Spark owns the high-volume event path and partitioned Parquet output. R provides an independent survival-analysis implementation. Airflow expresses dependency order. DuckDB is the tested local warehouse fallback; BigQuery is intentionally not deployed without credentials. Power BI is the primary BI design, while Tableau is omitted because it would duplicate the decision experience.

## Quick start

Prerequisites: `uv`, Python 3.9 or newer, and Git. Java 11 or 17 is required only for Spark. R plus the `survival` package is required only for the independent R analysis. Power BI Desktop is required to assemble and visually test the native report.

```bash
uv sync --extra dev
make generate
make validate
make load
make dbt
make analytics
make test
```

Optional distributed-event check:

```bash
uv sync --extra spark --extra dev
make spark
```

Optional R check:

```bash
Rscript r/survival_analysis.R
```

The full local command sequence was tested except Spark execution, R execution, and native Power BI rendering. This host has no Java runtime, R runtime, or Power BI Desktop. Spark therefore has no benchmark claim, and no dashboard screenshot or `.pbix` is fabricated.

## Data model and metrics

The raw layer includes customer, account, product, plan, date, channel, sales, customer-success, geography, subscription, invoice, invoice-line, payment, refund, usage, support, marketing, lead, opportunity, contract, customer-health, and revenue-recognition entities. dbt publishes star-schema dimensions and revenue, growth, and finance marts.

The [metric dictionary](docs/metric_dictionary.md) records the governed target definition, grain, owner, inclusions, exclusions, limitations, and required test for each requested metric. Implemented marts and tests cover the revenue bridge, finance reconciliation, customer monthly health, and channel efficiency. Remaining catalog metrics are explicitly design targets, not falsely presented as completed models.

## Analytical methods

- Customer-month MRR movements reconcile opening MRR plus additions less losses to closing MRR.
- Billing reconciliation compares invoice totals, successful payments, failed payments, refunds, recognition, contract dates, currency, and subscription validity.
- Churn modeling uses strict train, calibration, and future test periods, calibrated logistic and gradient-boosting candidates, lift, PR-AUC, ROC-AUC, Brier score, and an explicit intervention-cost threshold.
- Forecasting compares naive, seasonal-naive, and drift methods with rolling-origin backtests. Scenarios remain labeled assumptions.
- R implements Kaplan-Meier and Cox proportional-hazards analysis, with a Python cross-check.

## Power BI delivery

The [report design](powerbi/report_design.md), [semantic model](powerbi/semantic_model.md), [explicit DAX library](powerbi/measures.dax), and [QA checklist](powerbi/qa_checklist.md) specify eight decision-focused pages, drill-through, tooltips, date intelligence, dynamic titles, accessibility, and warehouse reconciliation. BI-ready CSV exports are created in `data/exports/`. Native report construction remains a documented manual step because Power BI Desktop is unavailable on this macOS host.

## Findings and recommendations

The synthetic closing-month contraction is primarily churn-driven. Finance outputs identify contract dates as the largest exception class and quantify $1.400 million of failed-payment exposure. Based on simulated evidence, the first priorities are to correct contract lifecycle rules, implement failed-payment recovery queues, focus retention review on cost-selected high-risk accounts, audit discount governance, and monitor acquisition cohorts. See the [executive report](reports/executive_summary.md). None of these recommendations has been implemented in a real company.

## Repository guide

- [Business requirements](docs/business_requirements.md)
- [Architecture](docs/architecture.md)
- [Synthetic-data methodology](docs/synthetic_data_methodology.md)
- [Metric dictionary](docs/metric_dictionary.md)
- [Technical report](reports/technical_report.md)
- [Interview guide](docs/interview_guide.md)
- [Demonstration script](docs/demo_script.md)
- [Limitations and ethics](docs/limitations_and_ethics.md)
- [Résumé bullets](resume_bullets.md)

## Limitations

This is a portfolio simulation, not a production deployment. Source behaviors are simplified, foreign-exchange rates are illustrative, causal claims are out of scope, and model outcomes depend on synthetic assumptions. Spark code, the R runtime, BigQuery, Airflow scheduling, and native Power BI interactions require environments not available during this build. See [limitations and ethics](docs/limitations_and_ethics.md) for the full disclosure.
