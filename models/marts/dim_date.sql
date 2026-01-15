-- This overrides the config in dbt_project.yml, and this model will not require tests
{{ config(required_tests=None) }}

select * from {{ ref('stg_date') }}