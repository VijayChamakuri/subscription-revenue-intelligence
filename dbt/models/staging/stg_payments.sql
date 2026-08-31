select cast(payment_id as varchar) payment_id, cast(invoice_id as varchar) invoice_id,
       cast(customer_id as varchar) customer_id, cast(payment_at as timestamp) payment_at,
       lower(cast(status as varchar)) status, cast(amount as decimal(18,2)) amount,
       upper(cast(currency as varchar)) currency, cast(failure_reason as varchar) failure_reason
from {{ source('raw', 'payments') }}

