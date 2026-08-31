select cast(product_id as varchar) product_id, cast(product_name as varchar) product_name,
       cast(product_family as varchar) product_family, cast(gross_margin_pct as decimal(9,6)) gross_margin_pct
from {{ source('raw', 'products') }}

