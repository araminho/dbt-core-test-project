select *
from {{ ref('dim_employee') }}
where valid_to_datetime is not null
  and valid_to_datetime <= valid_from_datetime
