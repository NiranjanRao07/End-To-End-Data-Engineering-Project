# Stock Data Analytics with Airflow and DBT

## Project Overview
This project leverages **Apache Airflow** and **dbt (Data Build Tool)** to build an end-to-end data pipeline for stock data analytics. The pipeline ingests raw stock prices, calculates financial indicators (Moving Average and RSI), and validates data quality through automated tests. The output is a set of transformed data models in Snowflake, optimized for further analysis.

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Airflow DAG Workflow](#airflow-dag-workflow)
- [DBT Models](#dbt-models)
- [Data Quality and Testing](#data-quality-and-testing)
- [Folder Structure](#folder-structure)
- [Future Improvements](#future-improvements)
- [Acknowledgments](#acknowledgments)

## Architecture
1. **Data Ingestion**: Raw stock prices are stored in Snowflake in the `STOCK_DATA_DB.RAW_DATA.STOCK_PRICES` table.
2. **Data Transformation**: Using dbt models, the pipeline calculates:
   - **Moving Averages**: 50-day and 200-day moving averages.
   - **RSI (Relative Strength Index)**: 14-day RSI to analyze stock momentum.
3. **Data Testing and Quality Assurance**: dbt tests are applied to ensure data consistency and quality, such as ensuring non-null and unique values where required.

## Technologies Used
- **Apache Airflow**: Workflow management and scheduling.
- **dbt**: Data transformation and modeling in Snowflake.
- **Snowflake**: Cloud data warehousing.
- **Docker**: Containerized environment setup.
- **Python**: Scripting and ETL logic.

## Getting Started
### Prerequisites
- **Docker** and **Docker Compose** installed on your local machine.
- Snowflake account and credentials.
- dbt profile setup in Airflow for Snowflake connection.

### Installation and Setup
1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. **Setup Environment Variables**:
   Configure Snowflake environment variables in your `.env` file (not included for security).

3. **Start the Docker Environment**:
   ```bash
   docker-compose up -d
   ```

4. **Access Airflow**:
   Open your browser and navigate to [http://localhost:8080](http://localhost:8080) to access the Airflow UI.

## Airflow DAG Workflow
The Airflow DAG `BuildELT_dbt` orchestrates the data pipeline, with the following tasks:
1. **dbt_run_moving_average**: Calculates the 50-day and 200-day moving averages.
2. **dbt_run_rsi**: Calculates the 14-day RSI.
3. **dbt_test**: Runs dbt tests to validate the data quality.
4. **dbt_snapshot**: Captures snapshots of historical data for audit and analysis.

## DBT Models
### 1. `moving_average`
Calculates:
- 50-day moving average (`ma_50`)
- 200-day moving average (`ma_200`)

### 2. `rsi`
Calculates:
- 14-day RSI to evaluate the stock’s momentum.

### SQL Logic for Models
These models use **window functions** to perform calculations, such as moving averages and lag-based calculations for RSI.

## Data Quality and Testing
Data quality is validated using dbt's testing framework, with tests including:
- **not_null**: Ensures no null values in important columns like `DATE` and `SYMBOL`.
- **unique**: Enforces unique combinations in `(DATE, SYMBOL)` to prevent duplicates.
- **Range checks**: Ensures RSI values are within the 0-100 range.

Any test failures are logged and flagged within Airflow, allowing for quick troubleshooting.

## Folder Structure
```plaintext
.
├── dags
│   ├── build_elt_with_dbt.py        # Airflow DAG definition
│   └── two_stocks.py                 # Additional DAG file
├── dbt
│   ├── models
│   │   ├── input
│   │   │   └── moving_average.sql    # SQL model for Moving Average
│   │   │   └── rsi.sql               # SQL model for RSI
│   │   └── output                    # Output models directory
│   ├── snapshots                     # Snapshots for historical data
│   ├── tests                         # Data quality tests
│   ├── dbt_project.yml               # dbt project configuration
│   └── profiles.yml                  # dbt profile for Snowflake
├── docker-compose.yaml               # Docker Compose configuration
└── README.md                         # Project documentation
```

## Acknowledgments
- **Apache Airflow** for orchestrating workflows.
- **dbt** for providing a robust transformation framework.
- **Snowflake** for hosting the cloud data warehouse.

---

This project serves as an example of a modern data pipeline for financial data, combining Airflow and dbt in a Dockerized environment to ensure scalability, reproducibility, and data quality.

Enjoy exploring the data and extending the pipeline as needed!
```
