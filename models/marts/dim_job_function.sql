{{ config(
    materialized='table'
) }}

select job_function_id as id,
       base_name,
       category,
       is_active,
       level,
       track,
       seniority_level,
       seniority_index
from {{ ref('stg_job_function_latest') }}
where job_function_id is not null