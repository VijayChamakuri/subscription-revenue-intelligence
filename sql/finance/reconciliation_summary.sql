select date_trunc('month', invoice_date)::date invoice_month,
       sum(total_amount) billed,
       sum(successful_payments) successful_payments,
       sum(refunded_amount) refunds,
       sum(net_collected_cash) net_collected_cash,
       sum(failed_payment_exposure) failed_payment_exposure,
       sum(recognized_amount) recognized_revenue,
       sum(deferred_amount) deferred_revenue,
       sum(payment_difference) payment_difference
from analytics_finance.fct_billing_reconciliation
group by 1 order by 1;

