select *
from {{ ref('fct_interview') }}
where interview_duration_minutes is not null
  and interview_duration_minutes < 0
