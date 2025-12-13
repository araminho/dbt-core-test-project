{{ config(
    materialized='table'
) }}

{{ generate_latest_state_model(
    stg_model_name='stg_employee',
    unique_key='employee_id'
) }}
