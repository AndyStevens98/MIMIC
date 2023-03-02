-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_observation table
--
-- Dependencies: run after
--      lk_observation
--      lk_procedure
--      lk_meas_chartevents
--      lk_cond_diagnoses
--      cdm_person.sql
--      cdm_visit_occurrence
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_observation
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_observation
(
    observation_id                integer              ,
    person_id                     integer     not null ,
    observation_concept_id        integer     not null ,
    observation_date              DATE      not null ,
    observation_datetime          timestamp           ,
    observation_type_concept_id   integer     not null ,
    value_as_number               decimal        ,
    value_as_string               varchar         ,
    value_as_concept_id           integer          ,
    qualifier_concept_id          integer          ,
    unit_concept_id               integer          ,
    provider_id                   integer          ,
    visit_occurrence_id           integer          ,
    visit_detail_id               integer          ,
    observation_source_value      varchar         ,
    observation_source_concept_id integer          ,
    unit_source_value             varchar         ,
    qualifier_source_value        varchar         ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

-- -------------------------------------------------------------------
-- Rules 1-4
-- lk_observation_mapped (demographics and DRG codes)
-- -------------------------------------------------------------------

INSERT INTO public.cdm_observation (
            person_id, observation_concept_id, observation_date, observation_datetime, observation_type_concept_id,
            value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id,
            visit_detail_id, observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value,
            unit_id, load_table_id)
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS observation_concept_id,
    CAST(src.start_datetime AS DATE)            AS observation_date,
    src.start_datetime                          AS observation_datetime,
    src.type_concept_id                         AS observation_type_concept_id,
    CAST(NULL AS decimal)                       AS value_as_number,
    src.value_as_string                         AS value_as_string,
    CASE
        WHEN src.value_as_string IS NOT NULL
            THEN COALESCE(src.value_as_concept_id, 0)
    END                                           AS value_as_concept_id,
    CAST(NULL AS integer)                         AS qualifier_concept_id,
    CAST(NULL AS integer)                         AS unit_concept_id,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS observation_source_value,
    src.source_concept_id                       AS observation_source_concept_id,
    CAST(NULL AS varchar)                        AS unit_source_value,
    CAST(NULL AS varchar)                        AS qualifier_source_value,
    --
    CONCAT('observation.', src.unit_id)         AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_observation_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Observation'
;


-- -------------------------------------------------------------------
-- Rule 6
-- lk_procedure_mapped
-- -------------------------------------------------------------------

INSERT INTO public.cdm_observation (
            person_id, observation_concept_id, observation_date, observation_datetime, observation_type_concept_id,
            value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id,
            visit_detail_id, observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value,
            unit_id, load_table_id)
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS observation_concept_id,
    CAST(src.start_datetime AS DATE)            AS observation_date,
    src.start_datetime                          AS observation_datetime,
    src.type_concept_id                         AS observation_type_concept_id,
    CAST(NULL AS decimal)                       AS value_as_number,
    CAST(NULL AS varchar)                        AS value_as_string,
    CAST(NULL AS integer)                         AS value_as_concept_id,
    CAST(NULL AS integer)                         AS qualifier_concept_id,
    CAST(NULL AS integer)                         AS unit_concept_id,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS observation_source_value,
    src.source_concept_id                       AS observation_source_concept_id,
    CAST(NULL AS varchar)                        AS unit_source_value,
    CAST(NULL AS varchar)                        AS qualifier_source_value,
    --
    CONCAT('observation.', src.unit_id)         AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_procedure_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Observation'
;

-- -------------------------------------------------------------------
-- Rule 7
-- diagnoses
-- -------------------------------------------------------------------

INSERT INTO public.cdm_observation (
            person_id, observation_concept_id, observation_date, observation_datetime, observation_type_concept_id,
            value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id,
            visit_detail_id, observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value,
            unit_id, load_table_id)
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS observation_concept_id, -- to rename fields in *_mapped
    CAST(src.start_datetime AS DATE)            AS observation_date,
    src.start_datetime                          AS observation_datetime,
    src.type_concept_id                         AS observation_type_concept_id,
    CAST(NULL AS decimal)                       AS value_as_number,
    CAST(NULL AS varchar)                        AS value_as_string,
    CAST(NULL AS integer)                         AS value_as_concept_id,
    CAST(NULL AS integer)                         AS qualifier_concept_id,
    CAST(NULL AS integer)                         AS unit_concept_id,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS observation_source_value,
    src.source_concept_id                       AS observation_source_concept_id,
    CAST(NULL AS varchar)                        AS unit_source_value,
    CAST(NULL AS varchar)                        AS qualifier_source_value,
    --
    CONCAT('observation.', src.unit_id)         AS unit_id,
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
    src.target_domain_id = 'Observation'
;

-- -------------------------------------------------------------------
-- Rule 8
-- lk_specimen_mapped
-- -------------------------------------------------------------------

INSERT INTO public.cdm_observation (
            person_id, observation_concept_id, observation_date, observation_datetime, observation_type_concept_id,
            value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, provider_id, visit_occurrence_id,
            visit_detail_id, observation_source_value, observation_source_concept_id, unit_source_value, qualifier_source_value,
            unit_id, load_table_id)
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS observation_concept_id,
    CAST(src.start_datetime AS DATE)            AS observation_date,
    src.start_datetime                          AS observation_datetime,
    src.type_concept_id                         AS observation_type_concept_id,
    CAST(NULL AS decimal)                       AS value_as_number,
    CAST(NULL AS varchar)                        AS value_as_string,
    CAST(NULL AS integer)                         AS value_as_concept_id,
    CAST(NULL AS integer)                         AS qualifier_concept_id,
    CAST(NULL AS integer)                         AS unit_concept_id,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS observation_source_value,
    src.source_concept_id                       AS observation_source_concept_id,
    CAST(NULL AS varchar)                        AS unit_source_value,
    CAST(NULL AS varchar)                        AS qualifier_source_value,
    --
    CONCAT('observation.', src.unit_id)         AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_specimen_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|',
                COALESCE(CAST(src.hadm_id AS varchar), CAST(src.date_id AS varchar)))
WHERE
    src.target_domain_id = 'Observation'
;

-- -------------------------------------------------------------------
-- Rule 5
-- chartevents
-- -------------------------------------------------------------------

INSERT INTO public.cdm_observation
SELECT
    src.measurement_id                          AS observation_id, -- id is generated already
    per.person_id                               AS person_id,
    src.target_concept_id                       AS observation_concept_id,
    CAST(src.start_datetime AS DATE)            AS observation_date,
    src.start_datetime                          AS observation_datetime,
    src.type_concept_id                         AS observation_type_concept_id,
    src.value_as_number                         AS value_as_number,
    src.value_source_value                      AS value_as_string,
    CASE
        WHEN src.value_source_value IS NOT NULL
            THEN COALESCE(src.value_as_concept_id, 0)
    END                                         AS value_as_concept_id,
    CAST(NULL AS integer)                       AS qualifier_concept_id,
    src.unit_concept_id                         AS unit_concept_id,
    CAST(NULL AS integer)                       AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                       AS visit_detail_id,
    src.source_code                             AS observation_source_value,
    src.source_concept_id                       AS observation_source_concept_id,
    src.unit_source_value                       AS unit_source_value,
    CAST(NULL AS varchar)                       AS qualifier_source_value,
    --
    CONCAT('observation.', src.unit_id)         AS unit_id,
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
    src.target_domain_id = 'Observation'
;

-- This fills in the observation_id gaps
CREATE SEQUENCE cdm_observation_observation_id_seq;
ALTER TABLE cdm_observation ALTER COLUMN observation_id SET DEFAULT nextval('cdm_observation_observation_id_seq');
ALTER SEQUENCE cdm_observation_observation_id_seq owned by cdm_observation.observation_id;
SELECT setval('cdm_observation_observation_id_seq', (SELECT MAX(observation_id) from cdm_observation), TRUE);
UPDATE cdm_observation
    SET observation_id = nextval('cdm_observation_observation_id_seq')
WHERE observation_id is null;