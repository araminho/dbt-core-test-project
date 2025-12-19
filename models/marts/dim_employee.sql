{{ config(
    materialized='table'
) }}

select offset,
       employee_id as id,
       job_function_id,
       primary_skill_id,
       production_category,
       employment_status,
       org_category,
       org_category_type,
       DATE(work_start_at) as work_start_date,
       DATE(work_end_at)   as work_end_date,
       is_active,
       row_valid_from         as valid_from_datetime,
       row_valid_to           as valid_to_datetime

from {{ ref('stg_employee') }}