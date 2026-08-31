-- DuckDB query over dbt marts. Returns the auditable monthly MRR roll-forward.
select
  month_start,
  opening_mrr,
  new_mrr,
  expansion_mrr,
  reactivation_mrr,
  contraction_mrr,
  churned_mrr,
  net_new_mrr,
  closing_mrr,
  reconciliation_difference
from analytics_revenue.mart_mrr_bridge
order by month_start;

