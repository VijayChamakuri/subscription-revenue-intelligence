select cast(ticket_id as varchar) ticket_id, cast(customer_id as varchar) customer_id,
       cast(created_at as timestamp) created_at, cast(resolved_at as timestamp) resolved_at,
       lower(cast(priority as varchar)) priority, lower(cast(status as varchar)) status,
       cast(satisfaction_score as decimal(9,2)) satisfaction_score,
       cast(escalated as boolean) escalated
from {{ source('raw', 'support_tickets') }}

