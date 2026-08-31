# Independent survival analysis

Run `Rscript r/survival_analysis.R [customer_spells.csv] [output_directory]`.
The optional input is one row per customer spell with `tenure_months`, `churned`,
`plan_type`, `usage_decline`, `failed_payment`, and `support_escalation`. Without
an input file, the script uses a reproducible synthetic fixture with seed 42.

The outputs include Kaplan-Meier estimates, Cox hazard ratios with confidence
intervals, a proportional-hazards diagnostic, and source metadata. Hazard ratios
describe association, not causal effects. The Cox model assumes proportional
hazards, non-informative censoring, and correctly measured covariates.

