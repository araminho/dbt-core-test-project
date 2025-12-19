{{ config(
    materialized='table'
) }}

{{ generate_staging_model(
    table_name='job_functions',
    unique_key='job_function_id',
    updated_at_column='updated_at'
) }}
