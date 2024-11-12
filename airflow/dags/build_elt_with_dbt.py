from pendulum import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.hooks.base import BaseHook

conn = BaseHook.get_connection("snowflake_conn")
with DAG(
    "BuildELT_dbt",
    start_date=datetime(2024, 11, 9),
    description="A sample Airflow DAG to invoke dbt runs using a BashOperator",
    schedule=None,
    catchup=False,
    default_args={
        "env": {
            "DBT_USER": conn.login,
            "DBT_PASSWORD": conn.password,
            "DBT_ACCOUNT": conn.extra_dejson.get("account"),
            "DBT_SCHEMA": conn.schema,
            "DBT_DATABASE": conn.extra_dejson.get("database"),
            "DBT_ROLE": conn.extra_dejson.get("role"),
            "DBT_WAREHOUSE": conn.extra_dejson.get("warehouse"),
            "DBT_TYPE": "snowflake",
        }
    },
) as dag:
    dbt_run_moving_average = BashOperator(
        task_id="dbt_run_moving_average",
        bash_command="/home/airflow/.local/bin/dbt run --models moving_average --profiles-dir /opt/airflow/dbt --project-dir /opt/airflow/dbt",
        dag=dag,
    )

    dbt_run_rsi = BashOperator(
        task_id="dbt_run_rsi",
        bash_command="/home/airflow/.local/bin/dbt run --models rsi --profiles-dir /opt/airflow/dbt --project-dir /opt/airflow/dbt",
        dag=dag,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="/home/airflow/.local/bin/dbt test --profiles-dir /opt/airflow/dbt --project-dir /opt/airflow/dbt",
        dag=dag,
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",
        bash_command="/home/airflow/.local/bin/dbt snapshot --profiles-dir /opt/airflow/dbt --project-dir /opt/airflow/dbt",
        dag=dag,
    )

    # Set dependencies
    dbt_run_moving_average >> dbt_run_rsi >> dbt_test >> dbt_snapshot
