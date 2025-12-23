select *
from {{ ref('dim_employee') }}
where work_end_date is not null
  and work_end_date < work_start_date
