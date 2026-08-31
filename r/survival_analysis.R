#!/usr/bin/env Rscript

# Independent retention analysis. Input must be one row per completed or
# censored customer spell. Synthetic fallback data is clearly labeled.

args <- commandArgs(trailingOnly = TRUE)
input_path <- if (length(args) >= 1) args[[1]] else ""
output_dir <- if (length(args) >= 2) args[[2]] else "data/exports/modeling/r_survival"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("survival", quietly = TRUE)) {
  stop("The CRAN package 'survival' is required")
}

if (nzchar(input_path) && file.exists(input_path)) {
  customer_spells <- read.csv(input_path, stringsAsFactors = TRUE)
  source_label <- "curated_input"
} else {
  set.seed(42)
  n <- 1200
  plan_type <- sample(c("monthly", "annual"), n, replace = TRUE, prob = c(0.55, 0.45))
  usage_decline <- rbinom(n, 1, 0.28)
  failed_payment <- rbinom(n, 1, 0.10)
  support_escalation <- rbinom(n, 1, 0.16)
  linear_predictor <- 0.55 * (plan_type == "monthly") + 0.85 * usage_decline +
    0.70 * failed_payment + 0.45 * support_escalation
  event_time <- rexp(n, rate = 0.018 * exp(linear_predictor))
  censor_time <- runif(n, 12, 48)
  customer_spells <- data.frame(
    account_id = sprintf("A%06d", seq_len(n)),
    tenure_months = pmin(event_time, censor_time),
    churned = as.integer(event_time <= censor_time),
    plan_type = factor(plan_type),
    usage_decline = usage_decline,
    failed_payment = failed_payment,
    support_escalation = support_escalation
  )
  source_label <- "synthetic_fixture_seed_42"
}

required <- c("tenure_months", "churned", "plan_type", "usage_decline", "failed_payment", "support_escalation")
missing_columns <- setdiff(required, names(customer_spells))
if (length(missing_columns) > 0) stop(paste("Missing columns:", paste(missing_columns, collapse = ", ")))
if (any(customer_spells$tenure_months < 0) || any(!customer_spells$churned %in% c(0, 1))) stop("Invalid survival outcome")

survival_object <- survival::Surv(customer_spells$tenure_months, customer_spells$churned)
km_fit <- survival::survfit(survival_object ~ plan_type, data = customer_spells)
km_summary <- summary(km_fit)
km_output <- data.frame(
  stratum = as.character(km_summary$strata), time = km_summary$time,
  at_risk = km_summary$n.risk, events = km_summary$n.event,
  survival_probability = km_summary$surv, lower_95 = km_summary$lower, upper_95 = km_summary$upper
)
write.csv(km_output, file.path(output_dir, "kaplan_meier_by_plan.csv"), row.names = FALSE)

cox_fit <- survival::coxph(
  survival_object ~ plan_type + usage_decline + failed_payment + support_escalation,
  data = customer_spells, ties = "efron", x = TRUE
)
cox_summary <- summary(cox_fit)
coefficients <- data.frame(
  term = rownames(cox_summary$coefficients), coefficient = cox_summary$coefficients[, "coef"],
  hazard_ratio = cox_summary$coefficients[, "exp(coef)"], standard_error = cox_summary$coefficients[, "se(coef)"],
  p_value = cox_summary$coefficients[, "Pr(>|z|)"],
  lower_95 = cox_summary$conf.int[, "lower .95"], upper_95 = cox_summary$conf.int[, "upper .95"]
)
write.csv(coefficients, file.path(output_dir, "cox_coefficients.csv"), row.names = FALSE)

ph_test <- survival::cox.zph(cox_fit)
ph_table <- data.frame(term = rownames(ph_test$table), ph_test$table, row.names = NULL, check.names = FALSE)
write.csv(ph_table, file.path(output_dir, "proportional_hazards_test.csv"), row.names = FALSE)

metadata <- data.frame(
  source = source_label, rows = nrow(customer_spells), events = sum(customer_spells$churned),
  censored = sum(customer_spells$churned == 0), concordance = unname(cox_summary$concordance[[1]])
)
write.csv(metadata, file.path(output_dir, "analysis_metadata.csv"), row.names = FALSE)

cat(sprintf("Completed survival analysis: %d rows, %d churn events, source=%s\n",
            nrow(customer_spells), sum(customer_spells$churned), source_label))

