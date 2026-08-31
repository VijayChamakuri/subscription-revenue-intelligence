select cast(usage_id as varchar) usage_id, cast(customer_id as varchar) customer_id,
       cast(product_id as varchar) product_id, cast(usage_date as date) usage_date,
       cast(active_users as integer) active_users, cast(events_count as bigint) events_count,
       cast(features_used as integer) features_used, cast(core_feature_used as boolean) core_feature_used
from {{ source('raw', 'product_usage') }}

