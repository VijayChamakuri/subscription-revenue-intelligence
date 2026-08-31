# Business Requirements Document

## Product objective

The Subscription Revenue and Customer Growth Intelligence Platform is a decision system for a fictional B2B SaaS business. It unifies subscription, billing, cash, usage, support, sales, and marketing activity so Finance, Revenue Operations, Marketing, Customer Success, Product, and executives can use consistent definitions and trace results to tested records.

All project data is synthetic. Outputs describe patterns detected in the generated dataset, not real company outcomes.

## Users and decisions

| User | Decisions enabled | Primary outputs |
|---|---|---|
| Executive leadership | Where growth comes from, where it leaks, and which actions merit attention | KPI scorecard, MRR bridge, forecast scenarios, prioritized recommendations |
| Finance | Whether recurring revenue, invoices, cash, refunds, recognition, and deferrals reconcile | Revenue schedules, exception queues, close controls |
| Revenue Operations | Which plans, segments, and sales motions drive durable recurring revenue | Movement analysis, pipeline metrics, renewal and expansion views |
| Marketing | Which channels acquire customers with attractive retention and unit economics | CAC, cohort retention, payback, channel quality |
| Customer Success | Which accounts need intervention and why | Health score, churn risk, renewal queue, customer drill-through |
| Product | Which adoption and time-to-value patterns associate with retention and expansion | Feature adoption, engagement trends, cohort comparisons |

## Functional requirements

1. Generate deterministic, realistic source data with documented assumptions and impossible-state checks.
2. Process high-volume product events with Spark into partitioned Parquet and Hive-compatible tables.
3. Transform source data through dbt staging, intermediate, fact, dimension, and mart layers.
4. Calculate and test the metrics documented in `metric_dictionary.md`.
5. Reconcile monthly customer MRR from opening balance through movements to closing balance.
6. Reconcile contracts, invoices, payments, refunds, revenue recognition, and deferred revenue.
7. Produce actionable exception tables with stable identifiers, severity, and resolution context.
8. Analyze logo and revenue retention by relevant customer, product, contract, and acquisition cohorts.
9. Estimate unit economics with transparent assumptions and sensitivity ranges.
10. Build time-aware churn models with calibration, lift, explainability, and a cost-based threshold.
11. Independently validate a retention question in R and cross-check it against SQL or Python.
12. Backtest forecasts and label actual, forecast, and scenario values distinctly.
13. Publish decision-ready datasets for an eight-page Power BI report.
14. Orchestrate the reproducible workflow in Airflow with monitoring and failure visibility.

## Nonfunctional requirements

- SQL is the primary transformation and metric language.
- Random processes use fixed, recorded seeds.
- Local execution uses DuckDB; BigQuery is an optional adapter when credentials are supplied.
- Data contracts, tests, lineage, freshness expectations, and metric ownership are version controlled.
- Generated raw data, credentials, local databases, and rendered outputs are excluded from Git as appropriate.
- Every material claim in reports must be traceable to a generated output or test.
- Accessibility, clear empty states, and restrained visual density are required in BI specifications.

## Acceptance evidence

Completion requires a reproducible pipeline run, passing feasible checks, exact movement reconciliation, detectable finance exceptions, backtested forecasts, leakage-safe time validation, cross-language statistical agreement, dashboard-to-warehouse tie-outs, and an independent review with no unresolved material issue. Screenshots and measured findings remain pending until their source artifacts exist and are verified.

## Authorization boundaries

The project does not deploy cloud resources, purchase services, publish externally, access production systems, or use private data. BigQuery and Power BI Desktop execution require user-supplied environments and credentials. No Tableau artifact will be created unless it adds a distinct investigation experience and can be validated.
