{{ config(
    materialized='ephemeral',
    unique_key='id'
) }}

select CAST(_offset AS BIGINT) as offset,
       id,
       candidate_type,
       candidate_id,
       status,
       interviewer_id,
       location,
       TO_BOOLEAN(logged) as is_logged,
       TO_BOOLEAN(media_available) as is_media_available,
       run_type,
       type,
       media_status,
       invite_answer_status,
       TO_TIMESTAMP(_created_micros) as created_at,
       TO_TIMESTAMP(_updated_micros) as updated_at


from {{ source ('job', 'interviews') }}