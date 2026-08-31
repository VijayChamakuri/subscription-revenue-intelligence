{% test cents_close(model, expression_a, expression_b, tolerance=0.01) %}
select *
from {{ model }}
where abs(coalesce({{ expression_a }}, 0) - coalesce({{ expression_b }}, 0)) > {{ tolerance }}
{% endtest %}

