select cast(subscription_id as varchar) subscription_id, cast(customer_id as varchar) customer_id,
       cast(account_id as varchar) account_id, cast(product_id as varchar) product_id,
       cast(plan_id as varchar) plan_id, cast(contract_id as varchar) contract_id,
       lower(cast(status as varchar)) status, cast(start_date as date) start_date,
       cast(end_date as date) end_date, cast(trial_start_date as date) trial_start_date,
       cast(trial_end_date as date) trial_end_date, cast(quantity as integer) quantity,
       cast(unit_price as decimal(18,2)) unit_price, cast(discount_pct as decimal(9,6)) discount_pct,
       upper(cast(currency as varchar)) currency, cast(mrr as decimal(18,2)) mrr,
       cast(cancelled_at as timestamp) cancelled_at
from {{ source('raw', 'subscriptions') }}

