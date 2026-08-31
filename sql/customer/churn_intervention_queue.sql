-- Ranking is descriptive and does not imply that intervention causes retention.
with latest_health as (
  select *, row_number() over (partition by customer_id order by score_date desc) rn
  from raw.customer_health
), latest_activity as (
  select *, row_number() over (partition by customer_id order by month_start desc) rn
  from analytics_growth.mart_customer_monthly_health
)
select c.customer_id, c.customer_name, c.segment, h.risk_probability, h.risk_tier,
       a.mrr, a.events_count, a.ticket_count, a.failed_payments,
       h.risk_probability * a.mrr * 12 as annual_mrr_at_risk
from latest_health h
join latest_activity a on h.customer_id = a.customer_id and a.rn = 1
join analytics_core.dim_customer c using (customer_id)
where h.rn = 1
order by annual_mrr_at_risk desc;

