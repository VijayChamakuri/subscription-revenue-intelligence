# Power BI Report Specification

The primary BI deliverable is an eight-page Power BI report backed by tested export marts. This directory contains the semantic model, DAX measure library, page design, and QA checklist. A `.pbix` file and screenshots must not be claimed until authored and verified in Power BI Desktop.

## Required import tables

- `dim_date`, marked as the date table
- conformed account, product, plan, channel, geography, sales rep, and CSM dimensions
- monthly MRR movement
- customer cohort retention
- customer health and churn scores
- sales and marketing funnel and unit economics
- finance reconciliation and revenue schedules
- forecast scenarios
- data-quality test results and refresh audit

Relationships use one-to-many, single-direction filtering from dimensions to facts. Bi-directional relationships and implicit measures are prohibited unless a documented exception is tested. Currency and percentage formats belong in the semantic model.

## Artifact status

| Artifact | Status |
|---|---|
| Semantic specification | Complete |
| DAX source | Complete as a specification; requires Power BI execution validation |
| Page design | Complete |
| QA checklist | Complete; execution pending report authoring |
| `.pbix` | Pending Power BI Desktop authoring |
| Screenshots | Pending verified report rendering |
