select cast(health_id as varchar) health_id, cast(customer_id as varchar) customer_id,
       cast(score_date as date) score_date, cast(health_score as decimal(9,4)) health_score,
       cast(risk_probability as decimal(9,6)) risk_probability, cast(risk_tier as varchar) risk_tier,
       cast(model_version as varchar) model_version
from {{ source('raw', 'customer_health') }}

