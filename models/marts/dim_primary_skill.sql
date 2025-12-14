{{ config(
    materialized='table'
) }}

select skill_id as id,
       is_active,
       type,
       name,
       url,
       parent_id
from {{ ref('stg_skill_latest') }}