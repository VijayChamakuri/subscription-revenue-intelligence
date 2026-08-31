select cast(csm_id as varchar) csm_id, cast(csm_name as varchar) csm_name,
       cast(team as varchar) team
from {{ source('raw', 'customer_success_managers') }}

