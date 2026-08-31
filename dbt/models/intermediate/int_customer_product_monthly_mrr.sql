select month_start, customer_id, product_id, plan_id, sum(mrr)::decimal(18,2) as mrr
from {{ ref('int_subscription_monthly_mrr') }}
group by 1,2,3,4

