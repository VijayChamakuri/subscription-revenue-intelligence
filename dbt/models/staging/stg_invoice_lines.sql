select cast(invoice_line_id as varchar) invoice_line_id, cast(invoice_id as varchar) invoice_id,
       cast(product_id as varchar) product_id, cast(plan_id as varchar) plan_id,
       cast(service_start_date as date) service_start_date, cast(service_end_date as date) service_end_date,
       cast(quantity as integer) quantity, cast(unit_price as decimal(18,2)) unit_price,
       cast(discount_amount as decimal(18,2)) discount_amount, cast(line_amount as decimal(18,2)) line_amount
from {{ source('raw', 'invoice_lines') }}

