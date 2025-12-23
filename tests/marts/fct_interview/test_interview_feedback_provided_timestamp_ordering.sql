select *
from {{ ref('fct_interview') }}
where feedback_provided_datetime  is not null
  and finished_datetime is not null
  and feedback_provided_datetime < finished_datetime
