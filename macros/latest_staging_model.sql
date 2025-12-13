{% macro generate_latest_state_model(
    stg_model_name,
    unique_key='offset'
) -%}

{# --------------------------------------------------
   Generates a model with only the latest active rows
   based on the staging models row_is_active flag
-------------------------------------------------- #}

select *
from {{ ref(stg_model_name) }}
where row_is_active = true

{%- endmacro %}
