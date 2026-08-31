with failed as (
  select count(*) failed_attempts from {{ ref('stg_payments') }} where status = 'failed'
), exposure as (
  select sum(failed_payment_exposure) exposure from {{ ref('fct_billing_reconciliation') }}
)
select * from failed cross join exposure
where failed_attempts > 0 and coalesce(exposure, 0) <= 0

