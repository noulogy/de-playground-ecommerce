SELECT
    sales_id,
    user_id,
    category_id,
    {{ clean_money('amount') }} as amount,
    created_at
FROM {{ source('public', 'fact_sales') }}