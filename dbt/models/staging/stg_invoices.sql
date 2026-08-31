select cast(invoice_id as varchar) invoice_id, cast(subscription_id as varchar) subscription_id,
       cast(customer_id as varchar) customer_id, cast(invoice_date as date) invoice_date,
       cast(due_date as date) due_date, lower(cast(status as varchar)) status,
       upper(cast(currency as varchar)) currency, cast(subtotal as decimal(18,2)) subtotal,
       cast(discount_amount as decimal(18,2)) discount_amount, cast(tax_amount as decimal(18,2)) tax_amount,
       cast(total_amount as decimal(18,2)) total_amount
from {{ source('raw', 'invoices') }}

