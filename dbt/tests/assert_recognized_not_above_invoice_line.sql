select il.invoice_line_id
from {{ ref('stg_invoice_lines') }} il
left join {{ ref('stg_revenue_recognition') }} rr using (invoice_line_id)
group by 1, il.line_amount
having sum(coalesce(rr.recognized_amount, 0)) > il.line_amount + 0.01

