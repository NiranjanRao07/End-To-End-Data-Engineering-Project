{% snapshot snapshot_stock_prices %}

{{
    config(
        target_schema = "snapshot",
        unique_key = "concat(DATE::string, SYMBOL)",
        strategy = "timestamp",
        updated_at = "DATE",
        invalidate_hard_deletes = true
    )
}}

SELECT * FROM {{ source('stock_data_db', 'stock_prices') }}

{% endsnapshot %}
