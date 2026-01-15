select _offset,
       candidate_id as id,
       nullif(primary_skill_id, '') as primary_skill_id,
       staffing_status,
       english_level,
       nullif(job_function_id, '') as job_function_id,
       row_valid_from as valid_from_datetime,
       row_valid_to   as valid_to_datetime
from {{ ref('stg_candidate') }}
where _offset is not null and candidate_id is not null