select cast(opportunity_id as varchar) opportunity_id, cast(customer_id as varchar) customer_id,
       cast(channel_id as varchar) channel_id, cast(sales_rep_id as varchar) sales_rep_id,
       cast(created_at as timestamp) created_at, cast(closed_at as timestamp) closed_at,
       lower(cast(stage as varchar)) stage, cast(amount as decimal(18,2)) amount,
       upper(cast(currency as varchar)) currency
from {{ source('raw', 'opportunities') }}

