SELECT
    s.sales_id,
    s.created_at AS transaction_date,
    s.amount,
    u.user_id,
    u.user_name,
    u.city AS city_at_transaction,
    u.user_tier AS tier_at_transaction
FROM {{ ref('stg_sales') }} s
LEFT JOIN {{ ref('stg_users') }} u
    ON s.user_id = u.user_id
    AND s.created_at BETWEEN u.effective_date AND COALESCE(u.end_date, NOW())