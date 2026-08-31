with usage as (
  select date_trunc('month', usage_date)::date month_start, customer_id,
         sum(events_count) events_count, avg(active_users) avg_active_users,
         max(features_used) features_used, bool_or(core_feature_used) core_feature_adopted
  from {{ ref('stg_product_usage') }} group by 1,2
), support as (
  select date_trunc('month', created_at)::date month_start, customer_id,
         count(*) ticket_count, count_if(escalated) escalated_tickets,
         avg(date_diff('hour', created_at, resolved_at)) avg_resolution_hours
  from {{ ref('stg_support_tickets') }} group by 1,2
), payments as (
  select date_trunc('month', payment_at)::date month_start, customer_id,
         count_if(status = 'failed') failed_payments,
         sum(case when status = 'failed' then amount else 0 end) failed_payment_exposure
  from {{ ref('stg_payments') }} group by 1,2
), mrr as (
  select month_start, customer_id, sum(closing_mrr) mrr,
         sum(contraction_mrr) contraction_mrr, sum(churned_mrr) churned_mrr
  from {{ ref('fct_mrr_movement') }} group by 1,2
)
select m.month_start, m.customer_id, m.mrr, m.contraction_mrr, m.churned_mrr,
       coalesce(u.events_count, 0) events_count, coalesce(u.avg_active_users, 0) avg_active_users,
       coalesce(u.features_used, 0) features_used, coalesce(u.core_feature_adopted, false) core_feature_adopted,
       coalesce(s.ticket_count, 0) ticket_count, coalesce(s.escalated_tickets, 0) escalated_tickets,
       s.avg_resolution_hours, coalesce(p.failed_payments, 0) failed_payments,
       coalesce(p.failed_payment_exposure, 0) failed_payment_exposure
from mrr m left join usage u using (month_start, customer_id)
left join support s using (month_start, customer_id)
left join payments p using (month_start, customer_id)

