WITH stock_data AS (
  SELECT * FROM {{ source('stock_data_db', 'stock_prices') }}
),
moving_averages AS (
  SELECT
    date,
    symbol,
    close,
    AVG(close) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS ma_50,
    AVG(close) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS ma_200
  FROM stock_data
)
SELECT * FROM moving_averages
