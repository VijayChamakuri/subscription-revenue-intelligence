with bounds as (
  select min(month_start) min_date, (max(month_start) + interval '1 month' - interval '1 day')::date max_date
  from {{ ref('int_month_spine') }}
)
select d::date as date_day, year(d) as year_number, quarter(d) as quarter_number,
       month(d) as month_number, monthname(d) as month_name, date_trunc('month', d)::date month_start,
       (date_trunc('month', d) + interval '1 month' - interval '1 day')::date month_end,
       dayofweek(d) in (0, 6) as is_weekend
from bounds, unnest(generate_series(min_date, max_date, interval '1 day')) as t(d)

