select *
from {{ ref('fct_interview') }}
where started_datetime is not null
  and finished_datetime is not null
  and finished_datetime < started_datetime
