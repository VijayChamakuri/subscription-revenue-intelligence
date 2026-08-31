# Source-to-Target Mapping

| Synthetic source | Raw grain | Processing | Canonical targets | Primary controls |
|---|---|---|---|---|
| accounts and contacts | account; contact | Python contract validation, key normalization | `dim_account`, `dim_customer`, geography assignments | unique IDs, valid hierarchy, no future creation |
| product and plan catalog | product; effective plan version | dbt effective-date modeling | `dim_product`, `dim_plan` | positive price, valid cadence, no overlapping versions |
| subscription ledger | subscription version and event | dbt state sequencing | `fact_subscriptions`, `fact_subscription_events`, `mart_mrr_movement` | valid transition graph, date ordering, bridge equality |
| billing ledger | invoice and line | dbt arithmetic and relationship checks | `fact_invoices`, `fact_invoice_lines` | header-line tie-out, duplicate detection, currency consistency |
| payment ledger | payment attempt and refund | dbt settlement logic | `fact_payments`, `fact_refunds` | refund ceiling, invoice match, accepted statuses |
| revenue schedules | line-period | dbt service-period allocation | `fact_revenue_recognition` | recognized plus deferred tie-out to eligible net line value |
| product events | raw event | Spark deduplication and daily aggregation; Parquet partitioning | `fact_product_usage` | event uniqueness, schema contract, partition completeness |
| support system | ticket | Python and dbt duration derivation | `fact_support_tickets` | chronology, accepted status and priority |
| marketing platform | channel-date-geography | dbt spend and funnel joins | `fact_marketing_spend`, `fact_leads` | nonnegative spend, valid channel, funnel chronology |
| CRM | opportunity version and contract | dbt snapshots and conformed keys | `fact_opportunities`, `fact_contracts`, sales rep dimension | stage transitions, amount ranges, contract dates |
| currency rates | currency-date | dbt point-in-time lookup | reporting-currency fields across finance marts | rate present, positive rate, no forward fill beyond policy |

Unknown or unmatched keys route to explicit sentinel dimension members where business-safe. They must also create a quality exception. Silent row loss is prohibited.
