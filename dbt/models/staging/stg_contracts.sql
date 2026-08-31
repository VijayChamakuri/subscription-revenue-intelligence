select cast(contract_id as varchar) contract_id, cast(customer_id as varchar) customer_id,
       cast(contract_start_date as date) contract_start_date, cast(contract_end_date as date) contract_end_date,
       upper(cast(currency as varchar)) currency, cast(contract_value as decimal(18,2)) contract_value,
       lower(cast(contract_type as varchar)) contract_type
from {{ source('raw', 'contracts') }}

