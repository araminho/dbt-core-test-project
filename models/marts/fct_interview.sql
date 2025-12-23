{{ config(
    materialized='table'
) }}

with interview_versions as (
    select *
    from {{ ref('stg_interview') }}
    where interview_id is not null
),

/* -------------------------------------------
   State of interview at creation time
------------------------------------------- */
interview_created_state as (

    select *
    from (
        select
            interview_id,
            candidate_type,
            candidate_id,
            interviewer_id,
            location,
            is_logged,
            is_media_available,
            run_type,
            type,
            media_status,
            invite_answer_status,
            created_at,
            row_number() over (
                partition by interview_id
                order by row_valid_from
            ) as rn
        from interview_versions
    )
    where rn = 1

),

/* -------------------------------------------
   Pivot status timestamps
------------------------------------------- */
status_timestamps as (

    select
        interview_id,

        min(case when status = 'REQUESTED'
                 then row_valid_from end) as requested_datetime,

        min(case when status = 'SCHEDULED'
                 then row_valid_from end) as scheduled_datetime,

        min(case when status = 'IN_PROGRESS'
                 then row_valid_from end) as started_datetime,

        min(case when status = 'PENDING_FEEDBACK'
                 then row_valid_from end) as finished_datetime,

        min(case when status in ('COMPLETED', 'COMPLETED__')
                 then row_valid_from end) as feedback_provided_datetime,

        min(case when status in ('CANCELLED', '__CANCELLED')
                 then row_valid_from end) as cancelled_datetime

    from interview_versions
    group by interview_id

),

/* -------------------------------------------
   Join candidate dimension AS OF creation
------------------------------------------- */
candidate_at_creation as (

    select
        dc._offset as candidate_offset,
        dc.id as candidate_id,
        dc.valid_from_datetime,
        dc.valid_to_datetime
    from {{ ref('dim_candidate') }} dc

)

select
    /* ---------------------------------------
       Keys
    --------------------------------------- */
    ics.interview_id as id,

    ics.candidate_type,
    cc.candidate_offset,

    /* ---------------------------------------
       Descriptive attributes (as of creation)
    --------------------------------------- */
    sil.status,
    ics.interviewer_id as interviewer_offset,
    ics.location,
    ics.is_logged,
    ics.is_media_available,
    ics.run_type,
    ics.type,
    ics.media_status,
    ics.invite_answer_status,

    /* ---------------------------------------
       Created timestamps
    --------------------------------------- */
    DATE(ics.created_at) as created_date,
    ics.created_at      as created_datetime,

    /* ---------------------------------------
       Status timestamps
    --------------------------------------- */
    status_timestamps.requested_datetime,
    status_timestamps.scheduled_datetime,
    status_timestamps.started_datetime,
    status_timestamps.finished_datetime,
    status_timestamps.feedback_provided_datetime,
    status_timestamps.cancelled_datetime,

    /* ---------------------------------------
       Metrics
    --------------------------------------- */
    case
        when status_timestamps.started_datetime is not null
         and status_timestamps.finished_datetime is not null
        then TIMESTAMP_DIFF(
            status_timestamps.finished_datetime,
            status_timestamps.started_datetime,
            MINUTE
        )
    end as interview_duration_minutes,

    case
        when status_timestamps.finished_datetime is not null
         and status_timestamps.feedback_provided_datetime is not null
        then TIMESTAMP_DIFF(
            status_timestamps.feedback_provided_datetime,
            status_timestamps.finished_datetime,
            DAY
        )
    end as feedback_delay_days

from interview_created_state as ics

join {{ ref('stg_interview_latest') }} as sil
  on ics.interview_id = sil.interview_id

left join status_timestamps
  on ics.interview_id = status_timestamps.interview_id

left join candidate_at_creation as cc
  on ics.candidate_id = cc.candidate_id
  and ics.created_at >= cc.valid_from_datetime
  and (
    cc.valid_to_datetime is null
    or ics.created_at < cc.valid_to_datetime
  )
