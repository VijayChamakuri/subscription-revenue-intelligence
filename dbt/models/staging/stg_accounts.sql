select
  cast(account_id as varchar) as account_id,
  cast(account_name as varchar) as account_name,
  lower(cast(account_status as varchar)) as account_status,
  cast(employee_count as integer) as employee_count,
  cast(sales_rep_id as varchar) as sales_rep_id,
  cast(csm_id as varchar) as csm_id
from {{ source('raw', 'accounts') }}

