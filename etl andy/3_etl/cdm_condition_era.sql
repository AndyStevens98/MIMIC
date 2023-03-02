-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_condition_era table
-- "standard" script
-- -------------------------------------------------------------------

CREATE OR REPLACE FUNCTION DATE_ADD(dt DATE, intvl INTERVAL) RETURNS TIMESTAMP(3) AS $$
BEGIN
RETURN CAST(dt AS TIMESTAMP(3)) + intvl;
END; $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION DATE_SUB(dt DATE, intvl INTERVAL) RETURNS TIMESTAMP(3) AS $$
BEGIN
RETURN CAST(dt AS TIMESTAMP(3)) - intvl;
END; $$
LANGUAGE PLPGSQL;

-- -------------------------------------------------------------------
-- Defining spans of time when the
-- Person is assumed to have a given
-- condition.
-- -------------------------------------------------------------------
CREATE TABLE public.tmp_target_condition
AS SELECT
    co.condition_occurrence_id                                              AS condition_occurrence_id,
    co.person_id                                                            AS person_id,
    co.condition_concept_id                                                 AS condition_concept_id,
    co.condition_start_date                                                 AS condition_start_date,
    COALESCE( co.condition_end_date,
              DATE_ADD (co.condition_start_date, INTERVAL '1' DAY))           AS condition_end_date
    -- Depending on the needs of data, include more filters in cteConditionTarget
    -- For example
    -- - to exclude unmapped condition_concept_id's (i.e. condition_concept_id = 0)
          -- from being included in same era
    -- - to set condition_era_end_date to same condition_era_start_date
          -- or condition_era_start_date + INTERVAL '1 day', when condition_end_date IS NULL
FROM
    public.cdm_condition_occurrence co
WHERE
    co.condition_concept_id != 0
;

CREATE TABLE public.tmp_dates_un_condition
    AS SELECT
        person_id                               AS person_id,
        condition_concept_id                    AS condition_concept_id,
        condition_start_date                    AS event_date,
        -1                                      AS event_type,
        ROW_NUMBER() OVER (
            PARTITION BY
                person_id,
                condition_concept_id
            ORDER BY
                condition_start_date)               AS start_ordinal
    FROM
        public.tmp_target_condition
UNION ALL
    SELECT
        person_id                                             AS person_id,
        condition_concept_id                                  AS condition_concept_id,
        DATE_ADD (CAST(condition_end_date as DATE), INTERVAL '30' DAY)        AS event_date,
        1                                                     AS event_type,
        NULL                                                  AS start_ordinal
    FROM
        public.tmp_target_condition
;

CREATE TABLE public.tmp_dates_rows_condition
AS SELECT
    person_id                       AS person_id,
    condition_concept_id            AS condition_concept_id,
    event_date                      AS event_date,
    event_type                      AS event_type,
    MAX(start_ordinal) OVER (
        PARTITION BY
            person_id,
            condition_concept_id
        ORDER BY
            event_date,
            event_type
        ROWS UNBOUNDED PRECEDING)   AS start_ordinal,
        -- this pulls the current START down from the prior rows
        -- so that the NULLs from the END DATES will contain a value we can compare with
    ROW_NUMBER() OVER (
        PARTITION BY
            person_id,
            condition_concept_id
        ORDER BY
            event_date,
            event_type)             AS overall_ord
        -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
FROM
    public.tmp_dates_un_condition
;

CREATE TABLE public.tmp_enddates_condition
AS SELECT
    person_id                                       AS person_id,
    condition_concept_id                            AS condition_concept_id,
    DATE_SUB (CAST(event_date as DATE), INTERVAL '30' DAY)          AS end_date  -- unpad the end date
FROM
    public.tmp_dates_rows_condition e
WHERE
    (2 * e.start_ordinal) - e.overall_ord = 0
;

CREATE TABLE public.tmp_conditionends
AS SELECT
    c.person_id                             AS person_id,
    c.condition_concept_id                  AS condition_concept_id,
    c.condition_start_date                  AS condition_start_date,
    MIN(e.end_date)                         AS era_end_date
FROM
    public.tmp_target_condition c
JOIN
    public.tmp_enddates_condition e
        ON  c.person_id            = e.person_id
        AND c.condition_concept_id = e.condition_concept_id
        AND e.end_date             >= c.condition_start_date
GROUP BY
    c.condition_occurrence_id,
    c.person_id,
    c.condition_concept_id,
    c.condition_start_date
;

-- -------------------------------------------------------------------
-- Load Table: Condition_era
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_condition_era
(
    person_id                   integer     not null ,
    condition_concept_id        integer     not null ,
    condition_era_start_date    DATE      not null ,
    condition_era_end_date      DATE      not null ,
    condition_occurrence_count  integer              ,
    --
    unit_id                       varchar,
    load_table_id                 varchar,
    load_row_id                   integer
)
;

-- -------------------------------------------------------------------
-- It is derived from the records in
-- the CONDITION_OCCURRENCE table using
-- a standardized algorithm.
-- 30 days window is allowed.
-- -------------------------------------------------------------------
INSERT INTO public.cdm_condition_era
SELECT
    person_id                                       AS person_id,
    condition_concept_id                            AS condition_concept_id,
    MIN(condition_start_date)                       AS condition_era_start_date,
    era_end_date                                    AS condition_era_end_date,
    COUNT(*)                                        AS condition_occurrence_count,
-- --
    'condition_era.condition_occurrence'            AS unit_id,
    CAST(NULL AS varchar)                            AS load_table_id
FROM
    public.tmp_conditionends
GROUP BY
    person_id,
    condition_concept_id,
    era_end_date
ORDER BY
    person_id,
    condition_concept_id
;

ALTER TABLE cdm_condition_era add condition_era_id serial;

DROP SEQUENCE cdm_condition_era_condition_era_id_seq CASCADE;

-- -------------------------------------------------------------------
-- Drop temporary tables
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS public.tmp_conditionends;
DROP TABLE IF EXISTS public.tmp_enddates_condition;
DROP TABLE IF EXISTS public.tmp_dates_rows_condition;
DROP TABLE IF EXISTS public.tmp_dates_un_condition;
DROP TABLE IF EXISTS public.tmp_target_condition;
-- -------------------------------------------------------------------
-- Loading finished
-- -------------------------------------------------------------------
