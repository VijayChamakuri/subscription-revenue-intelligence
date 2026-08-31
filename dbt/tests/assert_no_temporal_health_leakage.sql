select h.*
from {{ ref('stg_customer_health') }} h
join {{ ref('stg_subscriptions') }} s using (customer_id)
where h.score_date > coalesce(s.end_date, h.score_date)

