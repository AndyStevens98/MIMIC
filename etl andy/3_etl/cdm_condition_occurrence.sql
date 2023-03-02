-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
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
-- TRUNCATE TABLE is not supported, organize create
--
-- -------------------------------------------------------------------

-- 4,520 rows on demo

-- -------------------------------------------------------------------
-- cdm_condition_occurrence
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_condition_occurrence
(
    person_id                     integer     not null ,
    condition_concept_id          integer     not null ,
    condition_start_date          DATE      not null ,
    condition_start_datetime      timestamp           ,
    condition_end_date            DATE               ,
    condition_end_datetime        timestamp           ,
    condition_type_concept_id     integer     not null ,
    stop_reason                   varchar             ,
    provider_id                   integer              ,
    visit_occurrence_id           integer              ,
    visit_detail_id               integer              ,
    condition_source_value        varchar             ,
    condition_source_concept_id   integer              ,
    condition_status_source_value varchar             ,
    condition_status_concept_id   integer              ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

-- -------------------------------------------------------------------
-- Rule 1
-- diagnoses
-- -------------------------------------------------------------------

INSERT INTO public.cdm_condition_occurrence
SELECT
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    CAST(src.start_datetime AS DATE)        AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    CAST(src.end_datetime AS DATE)          AS condition_end_date,
    src.end_datetime                        AS condition_end_datetime,
    src.type_concept_id                     AS condition_type_concept_id,
    CAST(NULL AS varchar)                    AS stop_reason,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    CAST(NULL AS varchar)                    AS condition_status_source_value,
    CAST(NULL AS integer)                     AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id) AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_diagnoses_icd_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Condition'
;

-- -------------------------------------------------------------------
-- rule 2
-- Chartevents.value
-- -------------------------------------------------------------------

INSERT INTO public.cdm_condition_occurrence
SELECT
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    CAST(src.start_datetime AS DATE)        AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    CAST(src.start_datetime AS DATE)        AS condition_end_date,
    src.start_datetime                      AS condition_end_datetime,
    32817                                   AS condition_type_concept_id, -- EHR  Type Concept    Type Concept
    CAST(NULL AS varchar)                    AS stop_reason,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    CAST(NULL AS varchar)                    AS condition_status_source_value,
    CAST(NULL AS integer)                     AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id) AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_chartevents_condition_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Condition'
;



-- -------------------------------------------------------------------
-- rule 3
-- Chartevents
-- -------------------------------------------------------------------

INSERT INTO public.cdm_condition_occurrence
SELECT
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS condition_concept_id,
    CAST(src.start_datetime AS DATE)        AS condition_start_date,
    src.start_datetime                      AS condition_start_datetime,
    CAST(src.start_datetime AS DATE)        AS condition_end_date,
    src.start_datetime                      AS condition_end_datetime,
    src.type_concept_id                     AS condition_type_concept_id,
    CAST(NULL AS varchar)                    AS stop_reason,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS condition_source_value,
    COALESCE(src.source_concept_id, 0)      AS condition_source_concept_id,
    CAST(NULL AS varchar)                    AS condition_status_source_value,
    CAST(NULL AS integer)                     AS condition_status_concept_id,
    --
    CONCAT('condition.', src.unit_id) AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_chartevents_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Condition'
;

ALTER TABLE cdm_condition_occurrence ADD condition_occurrence_id serial;

DROP SEQUENCE cdm_condition_occurrence_condition_occurrence_id_seq CASCADE; -- This may give error when loading into a SQL Client about not existing but it will by the time this is run