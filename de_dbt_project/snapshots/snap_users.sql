{% snapshot snap_users %}

{{
    config(
        target_schema='dbt_dev',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='effective_date'
    )
}}

SELECT * FROM {{ source('public', 'dim_user_scd2') }}

{% endsnapshot %}