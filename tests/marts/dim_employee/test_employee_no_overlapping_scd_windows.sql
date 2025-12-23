with ordered as (
  select
    id,
    valid_from_datetime,
    valid_to_datetime,
    lead(valid_from_datetime) over (
      partition by id
      order by valid_from_datetime
    ) as next_valid_from
  from {{ ref('dim_employee') }}
)

select *
from ordered
where next_valid_from is not null
  and valid_to_datetime > next_valid_from
