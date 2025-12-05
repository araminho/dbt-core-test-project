{{ config(
    materialized='incremental',
) }}
select CAST(_offset AS BIGINT) as offset,
       candidate_id as id,
       primary_skill_id,
       staffing_status,
       english_level,
       job_function_id,
       TO_TIMESTAMP(_created_micros) as created_at,
       TO_TIMESTAMP(_updated_micros) as updated_at
from {{ source('job', 'candidates') }}

{% if is_incremental() %}
where _updated_micros > (select MAX(updated_at) from {{ this }})
{% endif %}