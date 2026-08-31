with duplicate_invoices as (
  select invoice_id, 'duplicate_invoice' exception_type, 'high' severity,
         'Invoice ID occurs more than once' details
  from {{ ref('stg_invoices') }} group by 1 having count(*) > 1
), invalid_subscription as (
  select i.invoice_id, 'paid_invoice_without_valid_subscription', 'high',
         'Paid invoice has no matching subscription'
  from {{ ref('stg_invoices') }} i
  left join {{ ref('stg_subscriptions') }} s using (subscription_id)
  where i.status = 'paid' and s.subscription_id is null
), payment_mismatch as (
  select invoice_id, 'payment_invoice_mismatch', 'high',
         'Invoice and payment allocation differ by more than one cent'
  from {{ ref('fct_billing_reconciliation') }}
  where status = 'paid' and abs(payment_difference) > 0.01
), invalid_discount as (
  select invoice_id, 'invalid_discount', 'medium',
         'Discount is negative or exceeds subtotal'
  from {{ ref('stg_invoices') }}
  where discount_amount < 0 or discount_amount > subtotal
), negative_revenue as (
  select invoice_id, 'negative_revenue_anomaly', 'high', 'Invoice amount is negative'
  from {{ ref('stg_invoices') }} where total_amount < 0
), currency_mismatch as (
  select i.invoice_id, 'currency_inconsistency', 'medium',
         'Invoice and subscription currencies differ'
  from {{ ref('stg_invoices') }} i join {{ ref('stg_subscriptions') }} s using (subscription_id)
  where i.currency <> s.currency
), contract_conflict as (
  select i.invoice_id, 'contract_date_conflict', 'medium',
         'Invoice date falls outside the linked contract'
  from {{ ref('stg_invoices') }} i
  join {{ ref('stg_subscriptions') }} s using (subscription_id)
  join {{ ref('stg_contracts') }} c using (contract_id)
  where i.invoice_date < c.contract_start_date or i.invoice_date > c.contract_end_date
), active_without_invoice as (
  select 'subscription:' || s.subscription_id as invoice_id, 'active_subscription_without_invoice', 'high',
         'Active subscription has no invoice in its start month'
  from {{ ref('stg_subscriptions') }} s
  left join {{ ref('stg_invoices') }} i
    on s.subscription_id = i.subscription_id
   and date_trunc('month', s.start_date) = date_trunc('month', i.invoice_date)
  where s.status = 'active' and i.invoice_id is null
)
select * from duplicate_invoices union all
select * from invalid_subscription union all
select * from payment_mismatch union all
select * from invalid_discount union all
select * from negative_revenue union all
select * from currency_mismatch union all
select * from contract_conflict union all
select * from active_without_invoice

