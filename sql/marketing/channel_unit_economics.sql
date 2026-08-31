select e.month_start, mc.channel_name, e.spend, e.leads, e.opportunities,
       e.wins, e.acquired_customers, e.customer_acquisition_cost,
       e.lead_to_opportunity_rate, e.opportunity_to_win_rate,
       e.avg_sales_cycle_days
from analytics_growth.mart_channel_efficiency e
join raw.marketing_channels mc using (channel_id)
order by e.month_start, e.spend desc;

