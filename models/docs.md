{% docs fct_interview %}
Fact table representing interviews and their full lifecycle.

**Grain**
- One row per interview (`id`).

**Key Concepts**
- The table captures multiple lifecycle timestamps (created, scheduled, started, finished, cancelled, feedback).
- Interview-related metrics are derived from these timestamps.

**Slowly Changing Dimension Joins**
- `candidate_offset` and `interviewer_offset` reference SCD records in `dim_candidate` and `dim_employee`.
- Offsets ensure the correct historical version of each entity is used at interview time.

**Derived Metrics**
- `interview_duration_minutes`: Time elapsed between interview start and finish.
- `feedback_delay_days`: Number of days between interview completion and feedback submission.

This model is intended to be the primary source for interview analytics, funnel analysis, and operational reporting.
{% enddocs %}

{% docs scd_offset %}
Surrogate key identifying a specific version of a slowly changing dimension record.

**Purpose**
- Each `_offset` represents a snapshot of an entity at a point in time.
- Multiple offsets may exist for the same natural ID (`id`) as attributes change.

**Usage**
- Fact tables must join to dimensions using `_offset`, not `id`,
  to preserve historical correctness.

**Example**
- A candidate may change job function over time.
- Interviews must link to the candidate attributes that were valid at interview time.

Failure to use `_offset` can result in inaccurate historical analysis.
{% enddocs %}

{% docs scd_validity_window %}
Validity window defining when a dimension record version is active.

**Semantics**
- `valid_from_datetime`: Timestamp when this version became active.
- `valid_to_datetime`: Timestamp when this version was superseded.
- A NULL `valid_to_datetime` indicates the current active version.

**SCD Type**
- Implements Slowly Changing Dimension Type 2 behavior.

**Usage Notes**
- Used for temporal joins and historical reconstruction.
- Must be consistent with `_offset` generation logic.

These fields should not overlap for the same natural ID.
{% enddocs %}
