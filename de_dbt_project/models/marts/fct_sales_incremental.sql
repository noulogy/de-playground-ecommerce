{{  
    config(
        materialized='incremental',
        unique_key='sales_id'
    )
}}

SELECT
    sales_id,
    user_id,
    amount,
    created_at,
    updated_at
FROM {{ ref('stg_sales') }}

{% if is_incremental() %}
    where created_at >= (SELECT max(updated_at) - INTERVAL '3 days' FROM {{ this }})
{% endif %}