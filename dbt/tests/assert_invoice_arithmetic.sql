select * from {{ ref('stg_invoices') }}
where abs(subtotal - discount_amount + tax_amount - total_amount) > 0.01

