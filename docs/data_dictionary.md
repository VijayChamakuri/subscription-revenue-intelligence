# Data Dictionary

This is the business-level dictionary. Physical column types and constraints belong in dbt schema documentation and source contracts. All facts must include a source identifier, ingestion timestamp, and deterministic row-level uniqueness test.

## Dimensions

| Model | Grain | Key fields | Important attributes | Core tests |
|---|---|---|---|---|
| `dim_customer` | One person or billing contact | `customer_key`, `customer_id` | account, role, created date, status | unique and nonnull key; valid account relationship |
| `dim_account` | One legal customer account | `account_key`, `account_id` | segment, industry, size, initial use case, acquisition date | unique key; accepted segment; valid dates |
| `dim_product` | One sellable product | `product_key`, `product_id` | product family, launch date, active flag | unique key; accepted family |
| `dim_plan` | One versioned commercial plan | `plan_key`, `plan_id` | product, cadence, list price, included seats, effective dates | unique key; positive price; nonoverlapping effective dates |
| `dim_date` | One calendar date | `date_key`, `date` | month, quarter, year, fiscal fields, month-end flag | contiguous dates; unique date |
| `dim_marketing_channel` | One acquisition channel | `channel_key`, `channel_id` | channel group, paid flag | unique key; accepted channel group |
| `dim_sales_rep` | One versioned sales representative | `sales_rep_key`, `sales_rep_id` | team, region, active dates | unique key; valid effective range |
| `dim_customer_success_manager` | One versioned CSM | `csm_key`, `csm_id` | team, region, active dates | unique key; valid effective range |
| `dim_geography` | One normalized geography | `geography_key` | country, region, currency, timezone | ISO code accepted; unique hierarchy |

## Facts and events

| Model | Grain | Core measures and dates | Required relationships | Core tests |
|---|---|---|---|---|
| `fact_subscriptions` | One subscription version | seats, unit price, discount, MRR; start/end | account, product, plan | unique version; dates ordered; MRR nonnegative; discount in range |
| `fact_subscription_events` | One subscription lifecycle event | event type, effective timestamp, old/new MRR | subscription, account | accepted event; state transition valid; no orphan |
| `fact_invoices` | One invoice | subtotal, discount, tax, total, due and paid dates, currency | account, subscription when applicable | unique invoice; arithmetic tie-out; valid status |
| `fact_invoice_lines` | One invoice line | quantity, unit price, discount, net amount, service period | invoice, product, subscription | unique line; line arithmetic; service dates ordered |
| `fact_payments` | One payment attempt | attempted, settled, fee amounts; status and timestamp | invoice, account | unique attempt; accepted status; amount nonnegative |
| `fact_refunds` | One refund | refund amount, reason, timestamp | payment, invoice, account | amount positive; refund not above settled amount |
| `fact_product_usage` | One account-product-date aggregate | events, active users, sessions, feature counts | account, product, date | unique grain; counts nonnegative; no future date |
| `fact_support_tickets` | One support ticket | priority, status, response and resolution durations | account, customer, dates | unique ticket; durations nonnegative; valid chronology |
| `fact_marketing_spend` | One channel-geography-date | spend, impressions, clicks | channel, geography, date | unique grain; measures nonnegative |
| `fact_leads` | One lead | created date, source, qualification state | channel, geography, account when converted | unique lead; accepted status; chronology |
| `fact_opportunities` | One opportunity version | stage, amount, probability, opened/closed dates | account, lead, rep, product | unique version; probability range; valid chronology |
| `fact_contracts` | One contract version | committed value, term, seats, start/end | account, subscription, product | unique version; dates ordered; amount nonnegative |
| `fact_customer_health` | One account as-of date | health score and component scores | account, date | unique grain; scores bounded; features as-of safe |
| `fact_revenue_recognition` | One invoice line-accounting period | recognized and deferred amounts | invoice line, account, date | unique grain; schedule tie-out; amounts valid |

## Analytical marts

| Model | Grain | Purpose |
|---|---|---|
| `mart_mrr_movement` | account-product-month | Auditable opening-to-closing MRR bridge and movement classification |
| `mart_finance_reconciliation` | reconciliation rule-record-period | Exception queue with amount, severity, and evidence |
| `mart_customer_cohorts` | cohort-account-month-age | Logo and revenue retention curves |
| `mart_unit_economics` | cohort-channel-period | CAC, LTV, gross-margin LTV, payback, and sensitivity inputs |
| `mart_churn_scores` | account-score-date | Calibrated probability, threshold, risk band, and explanation |
| `mart_forecast_scenarios` | metric-period-scenario | Actuals, backtests, forecasts, intervals, and controlled scenarios |
| `mart_powerbi_kpis` | reporting-period and slice | Certified export for KPI and tie-out validation |
