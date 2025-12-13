{{ config(
    materialized='table'
) }}

{{ generate_latest_state_model(
    stg_model_name='stg_job_function',
    unique_key='job_function_id'
) }}
