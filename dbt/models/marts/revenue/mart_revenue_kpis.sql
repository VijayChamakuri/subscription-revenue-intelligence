select month_start, closing_mrr, closing_mrr * 12 as arr, net_new_mrr,
       case when opening_mrr > 0 then (opening_mrr - contraction_mrr - churned_mrr) / opening_mrr end as gross_revenue_retention,
       case when opening_mrr > 0 then (opening_mrr + expansion_mrr + reactivation_mrr - contraction_mrr - churned_mrr) / opening_mrr end as net_revenue_retention,
       closing_mrr / nullif(sum(case when closing_mrr > 0 then 1 else 0 end) over (partition by month_start), 0) as average_revenue_per_active_row
from {{ ref('mart_mrr_bridge') }}
