# dbt analytics layer

This project treats SQL as the primary transformation language and DuckDB as the reproducible local warehouse. BigQuery can be added as a deployment target without changing business logic after replacing DuckDB-specific date-spine syntax.

## Contract

The ingestion pipeline must load the tables declared in `models/staging/_sources.yml` into schema `raw`, including `_loaded_at` for freshness checks. Monetary source columns remain in their transaction currency. Currency inconsistencies are surfaced as exceptions, and cross-currency totals must not be described as USD until upstream conversion is applied.

## Commands

```bash
cd dbt
cp profiles.yml.example profiles.yml
dbt deps
dbt source freshness --profiles-dir .
dbt build --profiles-dir .
dbt docs generate --profiles-dir .
```

The critical invariant is tested at customer-product-plan and company-month grains:

`opening MRR + new + expansion + reactivation - contraction - churn = closing MRR`

All source data and findings in this portfolio are synthetic. Forecasts, risk scores, scenarios, and opportunity values are modeled outputs rather than observed production impact.
