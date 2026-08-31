# Synthetic Data Methodology

## Disclosure

Every company, person, transaction, interaction, and outcome in this repository is synthetic. The dataset is designed for analytics-system evaluation and portfolio demonstration. It is not evidence about any real company, market, customer, or intervention.

## Reproducibility

- A single documented master seed initializes component-specific random generators.
- Stable identifiers derive from deterministic sequences or namespaced hashes.
- Configuration records the observation window, row targets, currencies, plan catalog, and behavioral probabilities.
- Generator version and configuration hash accompany each run manifest.
- Tests compare the same-seed manifest and selected aggregates across repeat runs.

## Generative design

Accounts receive plausible segment, geography, acquisition channel, initial use case, size, and acquisition date assignments. Conditional processes then generate trials, opportunities, contracts, subscriptions, billing schedules, payments, refunds, support, and product usage. Lifecycle hazards vary with observed attributes such as adoption, engagement decline, failed payments, support burden, tenure, plan, and prior downgrade. This creates learnable but imperfect associations without implying causality.

Multi-product adoption, monthly and annual cadence, upgrades, seat changes, contractions, cancellations, and reactivations are generated through constrained state transitions. Billing and recognition follow service periods. A small, configurable set of deliberate data-quality defects is injected into tagged records so exception detection can be verified without confusing those defects with normal business behavior.

## Validity constraints

- Trial conversion cannot precede trial start.
- Subscription, contract, invoice service, payment, refund, support, and usage timestamps cannot violate their required chronology.
- A cancellation cannot occur before activation; reactivation requires prior cancellation.
- Seats, prices, monetary amounts, and usage counts cannot be negative except explicitly tagged reversal records.
- Discounts remain within policy unless intentionally injected as a quality exception.
- Refunds cannot exceed settled payment value unless intentionally injected.
- Annual and monthly cadence drive consistent MRR normalization.
- Product events reference active accounts and valid products at event time.
- Currency conversion uses the rate effective on the defined accounting date.
- Churn-model features are computed only from data available on or before the score date.

## Scale and benchmark integrity

The event-row target is a configuration choice, not a claim of production big-data scale. Reports must state actual compressed and uncompressed sizes, row count, partitions, machine specifications, Spark version, worker configuration, cold or warm cache status, and repeated runtime observations. No benchmark value may be added before a measured run.

## Known simulation limitations

The generator simplifies human decision-making, competitive pressure, macroeconomics, sales incentives, accounting policy, seasonality, and product causality. Model performance on generated relationships may be more stable than performance on real data. Recommendations are decision hypotheses under documented assumptions, not proven interventions.
