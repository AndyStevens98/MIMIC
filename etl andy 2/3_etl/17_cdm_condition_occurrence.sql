-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_condition_occurrence table
--
-- Dependencies: run after
--      st_core.sql,
--      st_hosp.sql,
--      lk_cond_diagnoses.sql,
--      lk_meas_chartevents.sql,
--      cdm_person.sql,
--      cdm_visit_occurrence.sql
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create or replace
--
-- -------------------------------------------------------------------

-- 4,520 rows on demo

-- -------------------------------------------------------------------
-- cdm_condition_occurrence
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE mimiciv_etl.cdm_condition_occurrence
(
    person_id                     INTEGER     not null ,
    condition_concept_id          INTEGER     not null ,
    condition_start_date          DATE      not null ,
    condition_start_datetime      TIMESTAMP           ,
    condition_end_date            DATE               ,
    condition_end_datetime        TIMESTAMP           ,
    condition_type_concept_id     INTEGER     not null ,
    stop_reason                   VARCHAR             ,
    provider_id                   INTEGER              ,
    visit_occurrence_id           INTEGER              ,
    visit_detail_id               INTEGER              ,
    condition_source_value        VARCHAR             ,
    condition_source_concept_id   INTEGER              ,
    condition_status_source_value VARCHAR             ,
    condition_status_concept_id   INTEGER              ,
    --
    unit_id                       VARCHAR,
    load_table_id                 VARCHAR,
    load_row_id                   TEXT,
    trace_id                      VARCHAR
)
;

-- -------------------------------------------------------------------
-- Rule 1
-- diagnoses
-- -------------------------------------------------------------------

INSERT INTO mimiciv_etl.cdm_condition_occurrence
SELECT
    src.subject_id                          AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    src.start_datetime::DATE                AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    src.end_datetime::DATE                  AS condition_end_date,
    src.end_datetime                        AS condition_end_datetime,
    src.type_concept_id                     AS condition_type_concept_id,
    NULL::VARCHAR                           AS stop_reason,
    NULL::INTEGER                           AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    NULL::INTEGER                           AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    NULL::VARCHAR                           AS condition_status_source_value,
    NULL::INTEGER                           AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id)       AS unit_id,
    src.load_table_id                       AS load_table_id,
    src.load_row_id                         AS load_row_id,
    src.trace_id                            AS trace_id
FROM
    mimiciv_etl.lk_diagnoses_icd_mapped src
INNER JOIN
    mimiciv_etl.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(src.subject_id::VARCHAR, '|', src.hadm_id::VARCHAR)
WHERE
    src.target_domain_id = 'Condition'
;

-- -------------------------------------------------------------------
-- rule 2
-- Chartevents.value
-- -------------------------------------------------------------------

INSERT INTO mimiciv_etl.cdm_condition_occurrence
SELECT
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    src.start_datetime::DATE                AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    src.start_datetime::DATE                AS condition_end_date,
    src.start_datetime                      AS condition_end_datetime,
    32817                                   AS condition_type_concept_id, -- EHR  Type Concept    Type Concept
    NULL::VARCHAR                           AS stop_reason,
    NULL::INTEGER                           AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    NULL::INTEGER                           AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    NULL::VARCHAR                           AS condition_status_source_value,
    NULL::INTEGER                           AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id) AS unit_id,
    src.load_table_id               AS load_table_id,
    src.load_row_id                 AS load_row_id,
    src.trace_id                    AS trace_id
FROM
    mimiciv_etl.lk_chartevents_condition_mapped src
INNER JOIN
    mimiciv_etl.cdm_person per
        ON src.subject_id::VARCHAR = per.person_source_value
INNER JOIN
    mimiciv_etl.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(src.subject_id::VARCHAR, '|', src.hadm_id::VARCHAR)
WHERE
    src.target_domain_id = 'Condition'
;



-- -------------------------------------------------------------------
-- rule 3
-- Chartevents
-- -------------------------------------------------------------------

INSERT INTO mimiciv_etl.cdm_condition_occurrence
SELECT
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    src.start_datetime::DATE                AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    src.start_datetime::DATE                AS condition_end_date,
    src.start_datetime                      AS condition_end_datetime,
    src.type_concept_id                     AS condition_type_concept_id,
    NULL::VARCHAR                           AS stop_reason,
    NULL::INTEGER                           AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    NULL::INTEGER                           AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    NULL::VARCHAR                           AS condition_status_source_value,
    NULL::INTEGER                           AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id)       AS unit_id,
    src.load_table_id                       AS load_table_id,
    src.load_row_id                         AS load_row_id,
    src.trace_id                            AS trace_id
FROM
    mimiciv_etl.lk_chartevents_mapped src
INNER JOIN
    mimiciv_etl.cdm_person per
        ON src.subject_id::VARCHAR = per.person_source_value
INNER JOIN
    mimiciv_etl.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(src.subject_id::VARCHAR, '|', src.hadm_id::VARCHAR)
WHERE
    src.target_domain_id = 'Condition'
;

ALTER TABLE mimiciv_etl.cdm_condition_occurrence add condition_occurrence_id serial;
DROP SEQUENCE mimiciv_etl.cdm_condition_occurrence_condition_occurrence_id_seq CASCADE;
