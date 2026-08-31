select cast(sales_rep_id as varchar) sales_rep_id, cast(sales_rep_name as varchar) sales_rep_name,
       cast(team as varchar) team
from {{ source('raw', 'sales_reps') }}

