select cast(channel_id as varchar) channel_id, cast(channel_name as varchar) channel_name,
       cast(channel_group as varchar) channel_group
from {{ source('raw', 'marketing_channels') }}

