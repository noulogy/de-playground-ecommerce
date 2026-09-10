{% macro clean_money(column_name) %}
    CASE
        WHEN {{ column_name }}::text ~ '[0-9]'
        THEN CAST(
            REPLACE(
                REGEXP_REPLACE({{ column_name }}::text, '[^0-9,]', '', 'g'),
                ',', '.'
                ) AS NUMERIC
                )
        ELSE 0
    END
{% endmacro %}