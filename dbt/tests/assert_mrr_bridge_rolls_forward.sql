with bridge as (select * from {{ ref('mart_mrr_bridge') }}), compared as (
  select month_start, closing_mrr,
         lead(opening_mrr) over (order by month_start) next_opening_mrr
  from bridge
)
select * from compared
where next_opening_mrr is not null and abs(closing_mrr - next_opening_mrr) > 0.01

