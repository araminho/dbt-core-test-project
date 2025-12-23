select id
from {{ ref('dim_employee') }}
where valid_to_datetime is null
group by id
having count(*) != 1
