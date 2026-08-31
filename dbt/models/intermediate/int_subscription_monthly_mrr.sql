with subscription_months as (
  select s.subscription_id, s.customer_id, s.product_id, s.plan_id, m.month_start, m.month_end
  from {{ ref('stg_subscriptions') }} s
  cross join {{ ref('int_month_spine') }} m
  where m.month_end >= s.start_date
), ranked_events as (
  select sm.*, e.mrr_after,
         row_number() over (
           partition by sm.subscription_id, sm.month_start
           order by e.event_at desc, e.subscription_event_id desc
         ) as event_rank
  from subscription_months sm
  left join {{ ref('stg_subscription_events') }} e
    on sm.subscription_id = e.subscription_id
   and e.event_at < sm.month_start + interval '1 month'
)
select subscription_id, customer_id, product_id, plan_id, month_start,
       greatest(coalesce(mrr_after, 0), 0)::decimal(18,2) as mrr
from ranked_events
where event_rank = 1
