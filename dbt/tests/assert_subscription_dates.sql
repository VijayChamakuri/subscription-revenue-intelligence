select * from {{ ref('stg_subscriptions') }}
where end_date < start_date
   or trial_end_date < trial_start_date
   or discount_pct < 0 or discount_pct > 1
   or quantity <= 0

