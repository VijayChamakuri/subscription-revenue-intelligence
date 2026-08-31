with movement_base as (
  select month_start, customer_id, product_id, plan_id, mrr as closing_mrr,
         lag(mrr, 1, 0) over (partition by customer_id, product_id, plan_id order by month_start) as opening_mrr,
         count_if(mrr > 0) over (
           partition by customer_id, product_id, plan_id order by month_start
           rows between unbounded preceding and 1 preceding
         ) as prior_active_months
  from {{ ref('int_customer_product_monthly_mrr') }}
), classified as (
  select *, closing_mrr - opening_mrr as mrr_change,
    case
      when opening_mrr = 0 and closing_mrr > 0 and coalesce(prior_active_months, 0) = 0 then 'new'
      when opening_mrr = 0 and closing_mrr > 0 and prior_active_months > 0 then 'reactivation'
      when opening_mrr > 0 and closing_mrr = 0 then 'churn'
      when closing_mrr > opening_mrr then 'expansion'
      when closing_mrr < opening_mrr then 'contraction'
      else 'no_change'
    end as movement_type
  from movement_base
)
select *,
  case when movement_type = 'new' then mrr_change else 0 end as new_mrr,
  case when movement_type = 'expansion' then mrr_change else 0 end as expansion_mrr,
  case when movement_type = 'contraction' then abs(mrr_change) else 0 end as contraction_mrr,
  case when movement_type = 'churn' then abs(mrr_change) else 0 end as churned_mrr,
  case when movement_type = 'reactivation' then mrr_change else 0 end as reactivation_mrr
from classified

