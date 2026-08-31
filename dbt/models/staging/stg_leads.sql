select cast(lead_id as varchar) lead_id, cast(channel_id as varchar) channel_id,
       cast(created_at as timestamp) created_at, cast(converted_opportunity_id as varchar) converted_opportunity_id,
       lower(cast(status as varchar)) status
from {{ source('raw', 'leads') }}

