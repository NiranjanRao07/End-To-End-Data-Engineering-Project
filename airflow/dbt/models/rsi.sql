WITH stock_data AS (
  SELECT * FROM {{ source('stock_data_db', 'stock_prices') }}
),
price_changes AS (
  SELECT
    date,
    symbol,
    close,
    close - LAG(close) OVER (PARTITION BY symbol ORDER BY date) AS price_change
  FROM stock_data
),
gains_and_losses AS (
  SELECT
    date,
    symbol,
    price_change,
    CASE WHEN price_change > 0 THEN price_change ELSE 0 END AS gain,
    CASE WHEN price_change < 0 THEN ABS(price_change) ELSE 0 END AS loss
  FROM price_changes
),
average_gain_loss AS (
  SELECT
    date,
    symbol,
    AVG(gain) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_gain,
    AVG(loss) OVER (PARTITION BY symbol ORDER BY date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS avg_loss
  FROM gains_and_losses
),
rsi_calculation AS (
  SELECT
    date,
    symbol,
    100 - (100 / (1 + avg_gain / NULLIF(avg_loss, 0))) AS rsi
  FROM average_gain_loss
)
SELECT * FROM rsi_calculation
