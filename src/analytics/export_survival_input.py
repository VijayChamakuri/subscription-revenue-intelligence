"""Build project-integrated customer spells for R and Python survival analysis."""

from __future__ import annotations

import argparse
from pathlib import Path

import duckdb

QUERY = """
with payment_flags as (
  select i.account_id, max(case when p.status = 'failed' then 1 else 0 end) failed_payment
  from raw.fact_invoices i
  join raw.fact_payments p using(invoice_id)
  group by 1
), support_flags as (
  select account_id, max(case when escalated then 1 else 0 end) support_escalation
  from raw.fact_support_tickets group by 1
), health_flags as (
  select account_id,
         max(case when feature_adoption_rate < 0.40 or days_since_last_activity > 30
                  then 1 else 0 end) usage_decline
  from raw.fact_customer_health group by 1
)
select s.account_id,
       greatest(1, date_diff('month', cast(s.start_date as date),
         coalesce(cast(s.end_date as date), date '2025-12-31'))) tenure_months,
       case when s.status = 'canceled' then 1 else 0 end churned,
       s.contract_type plan_type,
       coalesce(h.usage_decline, 0) usage_decline,
       coalesce(p.failed_payment, 0) failed_payment,
       coalesce(t.support_escalation, 0) support_escalation
from raw.fact_subscriptions s
left join health_flags h using(account_id)
left join payment_flags p using(account_id)
left join support_flags t using(account_id)
where s.start_date is not null
order by s.account_id
"""


def export(database: Path, output: Path) -> int:
    output.parent.mkdir(parents=True, exist_ok=True)
    with duckdb.connect(str(database), read_only=True) as connection:
        connection.execute(
            "copy (" + QUERY + ") to ? (header, delimiter ',')", [str(output)]
        )
        rows = connection.execute("select count(*) from (" + QUERY + ")").fetchone()[0]
    return rows


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--database", type=Path, default=Path("data/warehouse/subscription.duckdb")
    )
    parser.add_argument(
        "--output", type=Path, default=Path("data/exports/survival_input.csv")
    )
    args = parser.parse_args()
    print(f"exported {export(args.database, args.output)} customer spells")
