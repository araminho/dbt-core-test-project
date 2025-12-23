select f.*
from {{ ref('fct_interview') }} f
join {{ ref('dim_candidate') }} d
  on f.candidate_offset = d._offset
where f.created_datetime < d.valid_from_datetime
   or (
       d.valid_to_datetime is not null
       and f.created_datetime >= d.valid_to_datetime
   )
