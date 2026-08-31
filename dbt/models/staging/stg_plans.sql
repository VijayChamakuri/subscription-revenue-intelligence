select cast(plan_id as varchar) plan_id, cast(product_id as varchar) product_id,
       cast(plan_name as varchar) plan_name, lower(cast(billing_frequency as varchar)) billing_frequency,
       cast(list_price as decimal(18,2)) list_price, cast(included_seats as integer) included_seats
from {{ source('raw', 'plans') }}

