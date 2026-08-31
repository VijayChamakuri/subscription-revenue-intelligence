select cast(spend_id as varchar) spend_id, cast(channel_id as varchar) channel_id,
       cast(spend_date as date) spend_date, cast(amount as decimal(18,2)) amount,
       upper(cast(currency as varchar)) currency
from {{ source('raw', 'marketing_spend') }}

