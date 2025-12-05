{{config(
    materialized='view',
)}}
select CAST(_offset as BIGINT) as offset,
       id,
       TO_BOOLEAN(is_active) as is_active,
       TO_BOOLEAN(is_primary) as is_primary,
       TO_BOOLEAN(is_key) as is_key,
       TO_BOOLEAN(is_key_reason) as is_key_reason,
       type,
       name,
       url,
       parent_id,
       TO_TIMESTAMP(_created_micros) as created_at,
       TO_TIMESTAMP(_updated_micros) as updated_at


from {{ source ('job', 'skills') }}