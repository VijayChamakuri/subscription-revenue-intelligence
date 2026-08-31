# Power BI QA Checklist

Status values: Pending, Pass, Fail, Not Applicable. Evidence must include the refresh identifier, page, filter state, expected warehouse value, observed value, and reviewer.

## Model and totals

- [ ] Relationships match the approved star schema and have expected cardinality and filter direction.
- [ ] Date table is contiguous, marked correctly, and covers all reporting dates.
- [ ] No unintended blank dimension members or fact-to-fact relationships exist.
- [ ] All report calculations use explicit measures.
- [ ] MRR bridge variance is within the defined currency rounding tolerance at total and sampled slice levels.
- [ ] MRR, ARR, movements, NRR, GRR, active accounts, invoices, cash, refunds, recognition, deferral, and exception totals match certified warehouse exports.
- [ ] Percentage totals recompute from numerator and denominator rather than averaging rows.
- [ ] Currency conversion and display units are consistent.

## Filters and interactions

- [ ] Every slicer changes only intended visuals.
- [ ] Cross-highlighting behavior is useful and not ambiguous.
- [ ] Reset-filter control restores the documented default state.
- [ ] Synchronized slicers remain consistent across relevant pages.
- [ ] Incompatible filters produce a clear empty state.
- [ ] Drill-through preserves intended context and supports return navigation.
- [ ] Tooltip pages show the correct row context, definition, denominator, and limitation.

## Date and scenario logic

- [ ] Month-end balances use the last valid date, not summed daily values.
- [ ] Prior-period and prior-year comparisons exclude incomplete periods by default.
- [ ] Cohort month age and renewal windows match warehouse calculations.
- [ ] Actual, forecast, and scenario values are never combined unintentionally.
- [ ] Scenario controls change only modeled outputs and display baseline assumptions.
- [ ] Forecast intervals, backtest windows, and model names are visible.

## Usability and accessibility

- [ ] Each visual answers the stated page question and redundant visuals are removed.
- [ ] Page density, reading order, alignment, labels, and whitespace are consistent.
- [ ] Contrast is adequate and color is not the sole carrier of meaning.
- [ ] Keyboard focus order and alternative text are configured.
- [ ] Text remains legible at normal display scale.
- [ ] Dynamic titles describe selected metric, period, and scope.
- [ ] Last refresh and metric-trust status appear consistently.

## Operational review

- [ ] Finance validates reconciliation samples from dashboard to source-level synthetic records.
- [ ] RevOps validates movement classification samples.
- [ ] Customer Success validates prioritization fields and threshold explanation.
- [ ] Marketing validates attribution and unit-economics assumptions.
- [ ] A second reviewer checks all eight pages with default and adversarial filter states.
- [ ] Screenshots are captured only after all material failures are resolved.
