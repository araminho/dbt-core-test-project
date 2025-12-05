{{config(
    materialized='view',
)}}
select CAST(_offset as BIGINT) as offset,
       job_function_id as id,
       base_name,
       category,
       TO_BOOLEAN(is_active) as is_active,
       CAST(level as INTEGER) as level,
       track,
       seniority_level,
       CAST(seniority_index as INTEGER) as seniority_index,
       TO_TIMESTAMP(_created_micros) as created_at,
       TO_TIMESTAMP(_updated_micros) as updated_at


from {{ source ('job', 'job_functions') }}