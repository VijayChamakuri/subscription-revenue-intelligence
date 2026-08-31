# Semantic Model

## Relationship policy

`dim_date` filters facts by the primary reporting date. Role-playing dates use inactive relationships activated in explicit measures, or separate role dimensions where persistent simultaneous filtering is required. Account, product, plan, channel, and geography dimensions filter facts at compatible grains. Many-to-many relationships require a tested bridge, never direct fact-to-fact joins.

## Measure policy

- Hide raw numeric fact columns from report authors.
- Use explicit measures only.
- Calculate percentages from summed numerators and denominators.
- Return blank for undefined ratios.
- Exclude incomplete periods from comparison measures unless the page explicitly opts in.
- Label actual, forecast, and scenario series in titles, legends, and tooltips.
- Store measure descriptions, format strings, owner, and source mart in model metadata.

## Calculation groups

A time-intelligence calculation group is justified for Current, Prior Month, Prior Year, Variance, Variance Percent, Rolling 3 Months, and Rolling 12 Months. It must not apply to semi-additive ending-balance measures without an explicit override. A scenario calculation group is not recommended because scenario selection is a model dimension and should remain visible to users.

## Security and drill-through

The portfolio model does not claim production row-level security. A production design would map user principal names to authorized regions or account portfolios. Customer drill-through shows only synthetic account identifiers, renewal timing, MRR movement history, usage, support, payment status, risk drivers, and exception evidence.

## Certified tie-outs

Each report refresh exports a reconciliation table containing warehouse totals for opening MRR, movements, closing MRR, invoices, cash, refunds, recognized revenue, deferred revenue, active accounts, and exception counts. Matching DAX measures must equal these values within the defined rounding tolerance before screenshots or findings are published.
