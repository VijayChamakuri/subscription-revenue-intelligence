select severity, exception_type, count(*) exception_count,
       list(invoice_id order by invoice_id) affected_records
from analytics_finance.mart_finance_exceptions
group by 1,2
order by case severity when 'high' then 1 when 'medium' then 2 else 3 end, exception_count desc;

