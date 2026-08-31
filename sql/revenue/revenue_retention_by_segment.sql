-- Logo and revenue retention must be interpreted separately.
with customer_month as (
  select m.month_start, c.segment, m.customer_id,
         sum(m.opening_mrr) opening_mrr, sum(m.closing_mrr) closing_mrr,
         sum(m.contraction_mrr) contraction_mrr, sum(m.churned_mrr) churned_mrr,
         sum(m.expansion_mrr) expansion_mrr, sum(m.reactivation_mrr) reactivation_mrr
  from analytics_revenue.fct_mrr_movement m
  join analytics_core.dim_customer c using (customer_id)
  group by 1,2,3
)
select month_start, segment,
       count_if(opening_mrr > 0) opening_logos,
       count_if(opening_mrr > 0 and closing_mrr = 0) churned_logos,
       1 - count_if(opening_mrr > 0 and closing_mrr = 0)::decimal / nullif(count_if(opening_mrr > 0), 0) logo_retention,
       (sum(opening_mrr) - sum(contraction_mrr) - sum(churned_mrr)) / nullif(sum(opening_mrr), 0) grr,
       (sum(opening_mrr) + sum(expansion_mrr) + sum(reactivation_mrr) - sum(contraction_mrr) - sum(churned_mrr)) / nullif(sum(opening_mrr), 0) nrr
from customer_month
group by 1,2 order by 1,2;

