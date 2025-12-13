{{ config(
    materialized='table'
) }}

{{ generate_latest_state_model(
    stg_model_name='stg_candidate',
    unique_key='candidate_id'
) }}
