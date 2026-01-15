-- This overrides the config in dbt_project.yml, and this model will not require tests
{{ config(required_tests=None) }}

with spine as (

    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "'1990-01-01'",
        end_date = "'2030-01-01'"
    ) }}

),

final as (
    select
        DATE(date_day)                                            as date,
        EXTRACT(YEAR FROM date_day)                               as year,
        EXTRACT(QUARTER FROM date_day)                            as quarter,
        EXTRACT(MONTH FROM date_day)                              as month,
        EXTRACT(DAY FROM date_day)                                as day,
        EXTRACT(WEEK FROM date_day)                               as week,
        EXTRACT(DAYOFWEEK FROM date_day)                          as day_of_week,
        FORMAT_DATE('%A', DATE(date_day))                         as day_name,
        FORMAT_DATE('%B', DATE(date_day))                         as month_name,
        IF(EXTRACT(DAYOFWEEK FROM date_day) IN (1,7), true, false) as is_weekend,
        false                                                     as is_holiday
    from spine
)

select *
from final
order by date
