with paid as (
  select invoice_id,
         sum(case when status = 'succeeded' then amount else 0 end) as successful_payments,
         sum(case when status = 'failed' then amount else 0 end) as failed_payment_exposure
  from {{ ref('stg_payments') }} group by 1
), refunded as (
  select invoice_id, sum(amount) as refunded_amount from {{ ref('stg_refunds') }} group by 1
), recognized as (
  select il.invoice_id, sum(rr.recognized_amount) recognized_amount,
         sum(rr.deferred_amount) deferred_amount
  from {{ ref('stg_invoice_lines') }} il
  left join {{ ref('stg_revenue_recognition') }} rr using (invoice_line_id)
  group by 1
)
select i.invoice_id, i.subscription_id, i.customer_id, i.invoice_date, i.status,
       i.currency, i.subtotal, i.discount_amount, i.tax_amount, i.total_amount,
       coalesce(p.successful_payments, 0) successful_payments,
       coalesce(p.failed_payment_exposure, 0) failed_payment_exposure,
       coalesce(r.refunded_amount, 0) refunded_amount,
       coalesce(rec.recognized_amount, 0) recognized_amount,
       coalesce(rec.deferred_amount, 0) deferred_amount,
       (i.total_amount - coalesce(p.successful_payments, 0))::decimal(18,2) payment_difference,
       (coalesce(p.successful_payments, 0) - coalesce(r.refunded_amount, 0))::decimal(18,2) net_collected_cash
from {{ ref('stg_invoices') }} i
left join paid p using (invoice_id)
left join refunded r using (invoice_id)
left join recognized rec using (invoice_id)
