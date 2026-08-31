# Interview Preparation Guide

## Two-minute explanation

I built a subscription revenue and customer growth intelligence platform for a fictional B2B SaaS company using entirely synthetic, reproducible data. The product connects subscription changes to billing, cash, revenue recognition, usage, support, marketing, and sales activity. SQL and dbt define the trusted model and metrics, Spark handles the largest event stream, Python generates data and runs forecasting and churn models, R independently validates retention, Airflow orchestrates the pipeline, and Power BI is designed for decisions across Finance, RevOps, Marketing, Customer Success, Product, and leadership.

The core control is an account-level monthly MRR bridge that must reconcile opening to closing balance. A second control traces contracts through invoices, payments, refunds, recognition, and deferred revenue, with explicit exception queues. Churn scoring uses time-aware validation and a business-cost threshold, while forecast scenarios are clearly separated from actuals. I would then state only the measured scale, test status, model metrics, and findings from the latest verified run.

## Five-minute technical walkthrough

1. Start with the business questions and metric governance, not the tools.
2. Show the deterministic generator, contracts, deliberate defect fixtures, and run manifest.
3. Trace product events through Spark, partitioned Parquet, and Hive-compatible definitions.
4. Walk through dbt layers, lineage, tests, and the MRR movement model.
5. Demonstrate contract, invoice, cash, refund, recognition, and deferred-revenue tie-outs.
6. Explain churn feature as-of logic, time splits, calibration, lift, and threshold economics.
7. Explain the R survival analysis, assumptions, and cross-language check.
8. Compare forecast candidates with rolling backtests and distinguish scenarios from forecasts.
9. Navigate the eight Power BI pages from executive KPI to synthetic record-level exception.
10. Close with verified findings, no more than five recommendations, limitations, and next steps for real data.

## Architecture decisions

- SQL and dbt own business truth because metric logic must be reviewable, testable, and reusable.
- Python owns procedural generation, validation, automation, machine learning, and forecasting.
- Spark is limited to the event log where partitioned processing and a measured benchmark justify it.
- DuckDB provides a reliable no-credential local baseline; BigQuery remains an optional cloud adapter.
- R is an independent statistical implementation, not a duplicate dashboard workflow.
- Power BI supports governed executive and operational decisions. Tableau is omitted unless it adds a validated, distinct investigation story.

## Likely technical questions

**What was difficult in SQL?** Discuss effective-dated joins, monthly subscription state, mutually exclusive movement classification, cohort month age, finance arithmetic, service-period allocation, and preventing aggregate fan-out.

**How do dbt tests help?** Explain uniqueness, relationships, accepted values, source freshness, custom bridge and reconciliation assertions, deliberate defect fixtures, and incremental-to-full-refresh equivalence.

**How do MRR and ARR differ from revenue?** MRR and ARR are normalized recurring run-rate measures. Recognized revenue follows delivery over service periods, invoices represent billing, and cash reflects settlement timing.

**How did you prevent leakage?** Every feature has an as-of time, joins prohibit future observations, splits move forward in time, preprocessing fits only training windows, and post-churn or future-renewal fields are excluded.

**Why calibration and lift?** Ranking alone does not make probabilities actionable. Calibration supports cost estimates, and lift shows concentration of outcomes in the prioritized population.

**What statistical assumptions matter?** Independence, censoring assumptions, proportional hazards where used, sufficient cohort sizes, multiple comparisons, and the distinction between association and causation.

**How was dashboard quality checked?** Certified export totals, explicit DAX, date and scenario logic, filter interactions, drill-through, tooltips, empty states, accessibility, and record-level sampling.

## Findings and recommendations answer template

State the exact period and denominator, the verified measurement, why it matters, the proposed action, modeled opportunity range and assumptions, implementation difficulty, risk, and post-action metric. Never say the project changed a real business.

## Honest synthetic-data explanation

Synthetic data let me demonstrate lifecycle complexity, controlled exceptions, reproducibility, and end-to-end testing without using confidential information. It also limits external validity. Model performance and findings reflect generated relationships, so I present them as detected project patterns and decision hypotheses, not market evidence.

## What changes with production data

Add source-system contracts and ownership, identity resolution, late-arriving data policy, audited accounting requirements, role-based access, privacy review, model monitoring, experimentation design, service-level objectives, incident response, and stakeholder sign-off. Re-estimate every behavioral assumption and never assume synthetic model performance transfers.

## Follow-up prompts to rehearse

- Show one account from subscription event to MRR movement and invoice.
- Explain how annual plans normalize to MRR.
- Show how a duplicate invoice is detected without double-counting exposure.
- Defend the churn threshold with a cost matrix.
- Explain a case where ROC-AUC looks acceptable but PR-AUC or calibration is weak.
- Explain cohort censoring and small-cohort warnings.
- Describe an incremental model failure mode and recovery.
- Identify the most important unresolved limitation.
