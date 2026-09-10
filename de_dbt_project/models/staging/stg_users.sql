SELECT
    surrogate_id,
    user_id,
    user_name,
    city,
    user_tier,
    effective_date,
    end_date,
    is_current
FROM {{ source('public', 'dim_user_scd2') }}