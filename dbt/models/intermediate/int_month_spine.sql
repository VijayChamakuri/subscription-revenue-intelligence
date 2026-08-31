with bounds as (
  select date_trunc('month', min(event_at))::date as min_month,
         date_trunc('month', max(event_at))::date as max_month
  from {{ ref('stg_subscription_events') }}
)
select month_start::date as month_start,
       (month_start + interval '1 month' - interval '1 day')::date as month_end
from bounds,
unnest(generate_series(min_month, max_month, interval '1 month')) as t(month_start)

