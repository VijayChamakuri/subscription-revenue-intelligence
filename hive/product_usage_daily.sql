CREATE EXTERNAL TABLE IF NOT EXISTS analytics.fact_product_usage_daily (
  event_date DATE, account_id STRING, event_count BIGINT, features_adopted BIGINT,
  session_minutes DOUBLE, last_activity_at TIMESTAMP
)
PARTITIONED BY (event_year INT, event_month INT)
STORED AS PARQUET
LOCATION '${PRODUCT_USAGE_DAILY_PATH}';

MSCK REPAIR TABLE analytics.fact_product_usage_daily;

