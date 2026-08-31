# Finance Reconciliation Workbook Specification

Excel is optional and serves one focused purpose: a review-friendly finance exception and scenario workbook exported from certified warehouse marts. It does not recalculate canonical metrics or replace Power BI.

## Proposed sheets

| Sheet | Purpose |
|---|---|
| Control | Run ID, refresh time, reporting currency, export hashes, warehouse totals, workbook tie-out status |
| MRR Bridge | Monthly opening, movement components, closing, and variance |
| Billing Reconciliation | Contract, invoice, payment, refund, recognition, and deferral totals |
| Exceptions | Filterable exception identifier, rule, severity, amount, owner, evidence, and resolution status |
| Scenario Inputs | Clearly highlighted assumptions with validation and documented ranges |
| Scenario Output | Formula-driven deltas labeled as modeled, with baseline and horizon |
| Metric Definitions | Definition, grain, owner, inclusion, exclusion, and limitation |

## Controls

- Canonical values arrive from immutable CSV exports with a run identifier.
- Workbook formulas compare displayed totals to control totals and flag any variance beyond rounding tolerance.
- Input cells are visually distinct from formulas and protected where practical.
- Scenario outputs cannot overwrite actual values.
- No macros, external credentials, hidden calculation logic, or manual pasted findings are required.

Artifact status: workbook generation and formula verification are pending a verified pipeline run.
