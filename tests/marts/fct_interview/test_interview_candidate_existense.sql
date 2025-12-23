select f.*
from {{ ref('fct_interview') }} f
left join {{ ref('dim_candidate') }} d
  on f.candidate_offset = d._offset
where f.candidate_offset is not null
  and d._offset is null
