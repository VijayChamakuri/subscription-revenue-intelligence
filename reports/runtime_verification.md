# Runtime Verification Record

All results below were measured locally on 2026-08-31 against deterministic synthetic data generated with seed `20260831`.

| Component | Verified result |
|---|---|
| Source contracts | 23 source tables passed schema, key, date, range, and relationship validation |
| dbt | 36 models and 71 data tests; all 104 resources passed with no deprecation warnings |
| Spark | PySpark 3.5.9 processed 600,000 events in 6.807 seconds using `local[*]` |
| Parquet and Hive | 481,956 account-day rows, 36 year/month partitions, and 600,000 source events reconciled through the Hive-compatible DDL |
| R survival | R analyzed 997 customer spells with 173 churn events; Cox concordance was 0.6391 |
| Independent cross-check | 54 Kaplan-Meier points matched Python within `5.56e-16` |
| Airflow | Airflow 2.11.2 `dags test` completed the generation-to-monitoring graph successfully |
| Power BI | Not verified; native Power BI Desktop is unavailable on this macOS host |

Spark benchmark context: Python 3.13.14, Apple arm64 macOS, 10 logical CPUs, 16 GiB memory, and a 33,946,959-byte CSV input. This is a local engineering benchmark, not a big-data or cloud-performance claim.

## Commands

```bash
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
uv sync --extra spark --extra airflow --extra dev
make pipeline-full

export AIRFLOW_HOME="$(mktemp -d)"
export AIRFLOW__CORE__LOAD_EXAMPLES=False
uv run --extra airflow airflow db migrate
make airflow-test
```
