{{ config(
    materialized='table'
) }}

{{ generate_staging_model(
    table_name='interviews',
    unique_key='interview_id',
    updated_at_column='updated_at'
) }}
