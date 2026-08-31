select cast(recognition_id as varchar) recognition_id, cast(invoice_line_id as varchar) invoice_line_id,
       cast(customer_id as varchar) customer_id, cast(recognition_date as date) recognition_date,
       cast(recognized_amount as decimal(18,2)) recognized_amount,
       cast(deferred_amount as decimal(18,2)) deferred_amount, upper(cast(currency as varchar)) currency
from {{ source('raw', 'revenue_recognition') }}
