{{ config(
    materialized='table',
) }}
select CAST(_offset AS BIGINT) as offset,
         employee_id as id,
         job_function_id,
         primary_skill_id,
         production_category,
         employment_status,
         org_category,
         org_category_type,
         TO_TIMESTAMP(work_start_micros) as work_start_date,
         TO_TIMESTAMP(work_end_micros) as work_end_date,
         is_active,
         TO_TIMESTAMP(_created_micros) as created_at,
         TO_TIMESTAMP(_updated_micros) as updated_at
from {{ source('job', 'employees') }}