with spine as (

    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "'1990-01-01'",
        end_date = "'2030-01-01'"
    ) }}

),

final as (
    select
        to_date(date_day)                          as date,
        year(date_day)                             as year,
        quarter(date_day)                          as quarter,
        month(date_day)                            as month,
        day(date_day)                              as day,
        week(date_day)                             as week,
        dayofweek(date_day)                        as day_of_week,
        dayname(date_day)                          as day_name,
        monthname(date_day)                        as month_name,
        iff(dayofweek(date_day) in (6,7), true, false) as is_weekend,
        false                                      as is_holiday
    from spine
)

select *
from final
order by date
