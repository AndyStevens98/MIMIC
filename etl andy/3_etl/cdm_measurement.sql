-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_measurement table
--
-- Dependencies: run after
--      cdm_person.sql,
--      cdm_visit_occurrence,
--      cdm_visit_detail,
--          lk_meas_labevents.sql,
--          lk_meas_chartevents,
--          lk_meas_specimen,
--          lk_meas_waveform.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create or replace
--
-- src_labevents: look closer to fields priority and specimen_id
-- src_labevents.value:
--      investigate if there are formatted values with thousand separators,
--      and if we need to use more complicated parsing.
-- -------------------------------------------------------------------



--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_measurement
(
    measurement_id                integer     not null ,
    person_id                     integer     not null ,
    measurement_concept_id        integer     not null ,
    measurement_date              DATE      not null ,
    measurement_datetime          timestamp           ,
    measurement_time              varchar             ,
    measurement_type_concept_id   integer     not null ,
    operator_concept_id           integer              ,
    value_as_number               decimal            ,
    value_as_concept_id           integer              ,
    unit_concept_id               integer              ,
    range_low                     decimal            ,
    range_high                    decimal            ,
    provider_id                   integer              ,
    visit_occurrence_id           integer              ,
    visit_detail_id               integer              ,
    measurement_source_value      varchar             ,
    measurement_source_concept_id integer              ,
    unit_source_value             varchar             ,
    value_source_value            varchar             ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

-- -------------------------------------------------------------------
-- Rule 1
-- LABS from labevents
-- demo:  115,272 rows from mapped 107,209 rows. Remove duplicates
-- -------------------------------------------------------------------

INSERT INTO public.cdm_measurement
SELECT
    src.measurement_id                      AS measurement_id,
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS measurement_concept_id,
    CAST(src.start_datetime AS DATE)        AS measurement_date,
    src.start_datetime                      AS measurement_datetime,
    CAST(NULL AS varchar)                    AS measurement_time,
    32856                                   AS measurement_type_concept_id, -- OMOP4976929 Lab
    src.operator_concept_id                 AS operator_concept_id,
    CAST(src.value_as_number AS decimal)    AS value_as_number,  -- to move CAST to mapped/clean
    CAST(NULL AS integer)                     AS value_as_concept_id,
    src.unit_concept_id                     AS unit_concept_id,
    src.range_low                           AS range_low,
    src.range_high                          AS range_high,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS measurement_source_value,
    src.source_concept_id                   AS measurement_source_concept_id,
    src.unit_source_value                   AS unit_source_value,
    src.value_source_value                  AS value_source_value,
    --
    CONCAT('measurement.', src.unit_id)     AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_meas_labevents_mapped src -- 107,209
INNER JOIN
    public.cdm_person per -- 110,849
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis -- 116,559
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|',
                COALESCE(CAST(src.hadm_id AS varchar), CAST(src.date_id AS varchar)))
WHERE
    src.target_domain_id = 'Measurement' -- 115,272
;

-- -------------------------------------------------------------------
-- Rule 2
-- chartevents
-- -------------------------------------------------------------------

INSERT INTO public.cdm_measurement
SELECT
    src.measurement_id                      AS measurement_id,
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS measurement_concept_id,
    CAST(src.start_datetime AS DATE)        AS measurement_date,
    src.start_datetime                      AS measurement_datetime,
    CAST(NULL AS varchar)                    AS measurement_time,
    src.type_concept_id                     AS measurement_type_concept_id,
    CAST(NULL AS integer)                     AS operator_concept_id,
    src.value_as_number                     AS value_as_number,
    src.value_as_concept_id                 AS value_as_concept_id,
    src.unit_concept_id                     AS unit_concept_id,
    CAST(NULL AS integer)                     AS range_low,
    CAST(NULL AS integer)                     AS range_high,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS measurement_source_value,
    src.source_concept_id                   AS measurement_source_concept_id,
    src.unit_source_value                   AS unit_source_value,
    src.value_source_value                  AS value_source_value,
    --
    CONCAT('measurement.', src.unit_id)     AS unit_id,
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
    src.target_domain_id = 'Measurement'
;

-- -------------------------------------------------------------------
-- Rule 3.1
-- Microbiology - organism
-- -------------------------------------------------------------------

INSERT INTO public.cdm_measurement
SELECT
    src.measurement_id                      AS measurement_id,
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS measurement_concept_id,
    CAST(src.start_datetime AS DATE)        AS measurement_date,
    src.start_datetime                      AS measurement_datetime,
    CAST(NULL AS varchar)                    AS measurement_time,
    src.type_concept_id                     AS measurement_type_concept_id,
    CAST(NULL AS integer)                     AS operator_concept_id,
    CAST(NULL AS decimal)                   AS value_as_number,
    COALESCE(src.value_as_concept_id, 0)    AS value_as_concept_id,
    CAST(NULL AS integer)                     AS unit_concept_id,
    CAST(NULL AS integer)                     AS range_low,
    CAST(NULL AS integer)                     AS range_high,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS measurement_source_value,
    src.source_concept_id                   AS measurement_source_concept_id,
    CAST(NULL AS varchar)                    AS unit_source_value,
    src.value_source_value                  AS value_source_value,
    --
    CONCAT('measurement.', src.unit_id)     AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_meas_organism_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis -- 116,559
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|',
                COALESCE(CAST(src.hadm_id AS varchar), CAST(src.date_id AS varchar)))
WHERE
    src.target_domain_id = 'Measurement'
;

-- -------------------------------------------------------------------
-- Rule 3.2
-- Microbiology - antibiotics
-- -------------------------------------------------------------------

INSERT INTO public.cdm_measurement
SELECT
    src.measurement_id                      AS measurement_id,
    per.person_id                           AS person_id,
    COALESCE(src.target_concept_id, 0)      AS measurement_concept_id,
    CAST(src.start_datetime AS DATE)        AS measurement_date,
    src.start_datetime                      AS measurement_datetime,
    CAST(NULL AS varchar)                    AS measurement_time,
    src.type_concept_id                     AS measurement_type_concept_id,
    src.operator_concept_id                 AS operator_concept_id, -- dilution comparison
    src.value_as_number                     AS value_as_number, -- dilution value
    COALESCE(src.value_as_concept_id, 0)    AS value_as_concept_id, -- resistance (interpretation)
    CAST(NULL AS integer)                     AS unit_concept_id,
    CAST(NULL AS integer)                     AS range_low,
    CAST(NULL AS integer)                     AS range_high,
    CAST(NULL AS integer)                     AS provider_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    CAST(NULL AS integer)                     AS visit_detail_id,
    src.source_code                         AS measurement_source_value, -- antibiotic name
    src.source_concept_id                   AS measurement_source_concept_id,
    CAST(NULL AS varchar)                    AS unit_source_value,
    src.value_source_value                  AS value_source_value, -- resistance source value
    --
    CONCAT('measurement.', src.unit_id)     AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_meas_ab_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis -- 116,559
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|',
                COALESCE(CAST(src.hadm_id AS varchar), CAST(src.date_id AS varchar)))
WHERE
    src.target_domain_id = 'Measurement'
;

