select cast(geography_id as varchar) geography_id, cast(country as varchar) country,
       cast(region as varchar) region, upper(cast(currency as varchar)) local_currency
from {{ source('raw', 'geographies') }}

