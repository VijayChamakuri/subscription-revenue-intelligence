select month_start, sum(opening_mrr)::decimal(18,2) opening_mrr,
       sum(new_mrr)::decimal(18,2) new_mrr, sum(expansion_mrr)::decimal(18,2) expansion_mrr,
       sum(contraction_mrr)::decimal(18,2) contraction_mrr, sum(churned_mrr)::decimal(18,2) churned_mrr,
       sum(reactivation_mrr)::decimal(18,2) reactivation_mrr,
       sum(new_mrr + expansion_mrr + reactivation_mrr - contraction_mrr - churned_mrr)::decimal(18,2) net_new_mrr,
       sum(closing_mrr)::decimal(18,2) closing_mrr,
       (sum(opening_mrr + new_mrr + expansion_mrr + reactivation_mrr - contraction_mrr - churned_mrr) - sum(closing_mrr))::decimal(18,2) reconciliation_difference
from {{ ref('fct_mrr_movement') }}
group by 1

