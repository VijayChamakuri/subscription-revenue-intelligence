with spend as (
  select date_trunc('month', spend_date)::date month_start, channel_id, sum(amount) spend
  from {{ ref('stg_marketing_spend') }} group by 1,2
), funnel as (
  select date_trunc('month', l.created_at)::date month_start, l.channel_id,
         count(*) leads, count(l.converted_opportunity_id) opportunities
  from {{ ref('stg_leads') }} l group by 1,2
), wins as (
  select date_trunc('month', closed_at)::date month_start, channel_id,
         count_if(stage = 'closed_won') wins,
         avg(case when closed_at is not null then date_diff('day', created_at, closed_at) end) avg_sales_cycle_days
  from {{ ref('stg_opportunities') }} group by 1,2
), acquired as (
  select date_trunc('month', created_at)::date month_start, acquisition_channel_id channel_id,
         count(*) acquired_customers
  from {{ ref('stg_customers') }} group by 1,2
)
select coalesce(s.month_start, f.month_start, w.month_start, a.month_start) month_start,
       coalesce(s.channel_id, f.channel_id, w.channel_id, a.channel_id) channel_id,
       coalesce(s.spend, 0) spend, coalesce(f.leads, 0) leads,
       coalesce(f.opportunities, 0) opportunities, coalesce(w.wins, 0) wins,
       coalesce(a.acquired_customers, 0) acquired_customers, w.avg_sales_cycle_days,
       s.spend / nullif(a.acquired_customers, 0) as customer_acquisition_cost,
       f.opportunities::decimal / nullif(f.leads, 0) as lead_to_opportunity_rate,
       w.wins::decimal / nullif(f.opportunities, 0) as opportunity_to_win_rate
from spend s full join funnel f using (month_start, channel_id)
full join wins w using (month_start, channel_id)
full join acquired a using (month_start, channel_id)

