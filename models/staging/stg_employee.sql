{{ config(
    materialized='table'
) }}

{{ generate_staging_model(
    table_name='employees',
    unique_key='employee_id',
    updated_at_column='updated_at'
) }}
