select b.month_start, b.opening_mrr, b.net_new_mrr, b.closing_mrr,
       b.reconciliation_difference, k.arr, k.gross_revenue_retention, k.net_revenue_retention
from {{ ref('mart_mrr_bridge') }} b
join {{ ref('mart_revenue_kpis') }} k using (month_start)
order by 1

