select *
from {{ ref('fct_interview') }}
where feedback_delay_days is not null
  and feedback_delay_days < 0
