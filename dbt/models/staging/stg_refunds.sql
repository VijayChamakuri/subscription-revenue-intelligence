select cast(refund_id as varchar) refund_id, cast(payment_id as varchar) payment_id,
       cast(invoice_id as varchar) invoice_id, cast(refund_at as timestamp) refund_at,
       cast(amount as decimal(18,2)) amount, upper(cast(currency as varchar)) currency,
       cast(reason as varchar) reason
from {{ source('raw', 'refunds') }}

