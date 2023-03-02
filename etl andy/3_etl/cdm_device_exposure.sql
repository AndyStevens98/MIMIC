-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_device_exposure table
--
-- Dependencies: run after
--      lk_drug_prescriptions.sql
--      lk_meas_chartevents.sql
--      cdm_person.sql
--      cdm_visit_occurrence.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_device_exposure
-- Rule 1 lk_drug_mapped
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_device_exposure
(
    person_id                       integer       not null ,
    device_concept_id               integer       not null ,
    device_exposure_start_date      DATE        not null ,
    device_exposure_start_datetime  timestamp             ,
    device_exposure_end_date        DATE                 ,
    device_exposure_end_datetime    timestamp             ,
    device_type_concept_id          integer       not null ,
    unique_device_id                varchar               ,
    quantity                        integer                ,
    provider_id                     integer                ,
    visit_occurrence_id             integer                ,
    visit_detail_id                 integer                ,
    device_source_value             varchar               ,
    device_source_concept_id        integer                ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;


INSERT INTO public.cdm_device_exposure
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS device_concept_id,
    CAST(src.start_datetime AS DATE)            AS device_exposure_start_date,
    src.start_datetime                          AS device_exposure_start_datetime,
    CAST(src.end_datetime AS DATE)              AS device_exposure_end_date,
    src.end_datetime                            AS device_exposure_end_datetime,
    src.type_concept_id                         AS device_type_concept_id,
    CAST(NULL AS varchar)                        AS unique_device_id,
    CAST(
        CASE WHEN ROUND(src.quantity) = src.quantity THEN src.quantity END
        AS integer)                               AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS device_source_value,
    src.source_concept_id                       AS device_source_concept_id,
    --
    CONCAT('device.', src.unit_id)  AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_drug_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|', CAST(src.hadm_id AS varchar))
WHERE
    src.target_domain_id = 'Device'
;


INSERT INTO public.cdm_device_exposure
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS device_concept_id,
    CAST(src.start_datetime AS DATE)            AS device_exposure_start_date,
    src.start_datetime                          AS device_exposure_start_datetime,
    CAST(src.start_datetime AS DATE)            AS device_exposure_end_date,
    src.start_datetime                          AS device_exposure_end_datetime,
    src.type_concept_id                         AS device_type_concept_id,
    CAST(NULL AS varchar)                        AS unique_device_id,
    CAST(
        CASE WHEN ROUND(src.value_as_number) = src.value_as_number THEN src.value_as_number END
        AS integer)                               AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS device_source_value,
    src.source_concept_id                       AS device_source_concept_id,
    --
    CONCAT('device.', src.unit_id)  AS unit_id,
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
    src.target_domain_id = 'Device'
;


ALTER TABLE cdm_device_exposure add device_exposure_id serial;

DROP SEQUENCE cdm_device_exposure_device_exposure_id_seq CASCADE;