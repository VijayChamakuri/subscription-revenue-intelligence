# Standalone decision queries

These DuckDB SQL files consume the tested dbt marts. They are intentionally thin presentation queries, not a parallel transformation layer.

- `revenue/mrr_movement_bridge.sql`: Finance-ready monthly MRR roll-forward.
- `revenue/revenue_retention_by_segment.sql`: Separate logo retention, GRR, and NRR by segment.
- `finance/reconciliation_summary.sql`: Billed, collected, refunded, recognized, and deferred amounts.
- `finance/exception_queue.sql`: Prioritized billing and contract data exceptions.
- `customer/churn_intervention_queue.sql`: Modeled annual MRR at risk for prioritization. This is not causal impact.
- `marketing/channel_unit_economics.sql`: Funnel and CAC diagnostics by acquisition channel.

Run after `dbt build` with `duckdb data/warehouse/subscription_revenue.duckdb < sql/<path>.sql` from the repository root.

