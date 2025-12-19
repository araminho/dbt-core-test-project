{% macro generate_staging_model(
    table_name,
    unique_key='offset',
    updated_at_column='updated_at'
) -%}

{# --------------------------------------------------
   1. Read transformation config from seed
-------------------------------------------------- #}

{%- set query_to_run -%}
select
  raw_column_name,
  target_column_name,
  target_data_type
from {{ ref('raw_to_stg_config') }}
where upper(raw_table_name) = upper('{{ table_name }}')
{%- endset -%}

{%- set results = run_query(query_to_run) -%}

{%- if execute -%}
    {%- set results_list = results.rows -%}
{%- else -%}
    {%- set results_list = [] -%}
{%- endif -%}

{# --------------------------------------------------
   2. Base projection (renaming + casting)
-------------------------------------------------- #}

with base as (

    select
    {%- for row in results_list %}
        {%- if row[2] == 'TIMESTAMP' %}
            TIMESTAMP_MICROS(SAFE_CAST({{ row[0] }} as INT64)) as {{ row[1] }}
        {%- elif row[2] != 'STRING' %}
            SAFE_CAST({{ row[0] }} as {{ row[2] }}) as {{ row[1] }}
        {%- else %}
            {{ row[0] }} as {{ row[1] }}
        {%- endif %}
        {%- if not loop.last %},{%- endif %}
    {%- endfor %}
    from {{ source('job', table_name) }}

),

{# --------------------------------------------------
   3. Apply snapshot semantics
-------------------------------------------------- #}

versioned as (
    select
        *,
        {{ updated_at_column }} as row_valid_from,
        lead({{ updated_at_column }})
            over (
                partition by {{ unique_key }}
                order by {{ updated_at_column }}
            ) as row_valid_to
    from base
),

final as (
    select
        *,
        row_valid_to is null as row_is_active
    from versioned
)

select * from final

{%- endmacro %}
