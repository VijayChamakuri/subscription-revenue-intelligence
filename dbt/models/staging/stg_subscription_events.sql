select cast(subscription_event_id as varchar) subscription_event_id,
       cast(subscription_id as varchar) subscription_id, cast(customer_id as varchar) customer_id,
       cast(event_at as timestamp) event_at, lower(cast(event_type as varchar)) event_type,
       cast(mrr_before as decimal(18,2)) mrr_before, cast(mrr_after as decimal(18,2)) mrr_after,
       cast(quantity_before as integer) quantity_before, cast(quantity_after as integer) quantity_after
from {{ source('raw', 'subscription_events') }}

