{% macro generate_staging_model(table_name) -%}
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

select
{%- for row in results_list %}
    {%- if row[2] == 'TIMESTAMP_NTZ' %}
        TO_TIMESTAMP({{ row[0] }}) as {{ row[1] }}
    {%- elif row[2] != 'STRING' %}
        cast({{ row[0] }} as {{ row[2] }}) as {{ row[1] }}
    {%- else %}
        {{ row[0] }} as {{ row[1] }}
    {%- endif %}
    {%- if not loop.last %},{%- endif %}
{%- endfor %}
from {{ source('job', table_name) }}
{%- endmacro %}
