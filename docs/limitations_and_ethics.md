# Limitations and Ethical Considerations

## Truthfulness

All records are synthetic. Findings can be described only as identified, quantified, estimated, simulated, recommended, projected under stated assumptions, or detected in the project dataset. No result demonstrates real-world revenue growth, churn reduction, customer impact, or implemented business change.

## Analytical limitations

- Generated relationships reflect generator assumptions and may be easier to model than real behavior.
- Right censoring, observation-window boundaries, small cohorts, and account identity changes can affect retention estimates.
- MRR is an operational normalization and is not recognized revenue, cash, bookings, or backlog.
- Revenue recognition logic is educational and must not be treated as audited accounting advice.
- CAC and LTV rely on attribution, cost allocation, gross margin, discount rate, and horizon assumptions.
- Forecast intervals reflect modeled uncertainty, not every business or macroeconomic shock.
- Associations between usage, support, payment behavior, and churn do not establish causation.
- BigQuery execution, Power BI rendering, and real cloud performance cannot be claimed without those environments.

## Responsible churn scoring

Risk scores support prioritization, not automatic adverse treatment. Protected characteristics and direct proxies should be excluded. Interventions should offer assistance, education, or service recovery rather than punitive pricing or reduced support. Teams should monitor calibration and error rates by legitimate operational segments, record overrides, provide human review, and sunset models that drift.

## Scenario integrity

Opportunity values must name the baseline, input change, time horizon, gross-margin assumption, intervention cost, eligibility, and uncertainty. Simulated savings or retained revenue are not booked results. Dashboard labels must prevent users from mixing actuals with forecasts or scenarios.

## Privacy and security posture

The repository must contain no secrets, credentials, private data, or confidential assessments. Synthetic names should not intentionally reproduce real people or companies. A production adaptation would require access controls, retention rules, encryption, audit logging, data minimization, privacy review, and jurisdiction-specific compliance.
