select
  cast(customer_id as varchar) as customer_id,
  cast(account_id as varchar) as account_id,
  cast(customer_name as varchar) as customer_name,
  lower(cast(segment as varchar)) as segment,
  cast(initial_use_case as varchar) as initial_use_case,
  cast(acquisition_channel_id as varchar) as acquisition_channel_id,
  cast(geography_id as varchar) as geography_id,
  cast(created_at as timestamp) as created_at,
  cast(first_value_at as timestamp) as first_value_at
from {{ source('raw', 'customers') }}

