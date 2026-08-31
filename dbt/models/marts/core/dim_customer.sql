select c.customer_id, c.customer_name, c.segment, c.initial_use_case,
       c.created_at::date as acquisition_date, c.first_value_at,
       date_diff('day', c.created_at, c.first_value_at) as days_to_first_value,
       c.acquisition_channel_id, mc.channel_name as acquisition_channel,
       c.geography_id, g.country, g.region, c.account_id,
       a.account_name, a.employee_count, a.sales_rep_id, a.csm_id
from {{ ref('stg_customers') }} c
left join {{ ref('stg_accounts') }} a using (account_id)
left join {{ ref('stg_marketing_channels') }} mc on c.acquisition_channel_id = mc.channel_id
left join {{ ref('stg_geographies') }} g using (geography_id)

