-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_procedure_occurrence table
--
-- Dependencies: run after
--      cdm_person.sql,
--      cdm_visit_occurrence,
--      lk_procedure_occurrence
--      lk_meas_specimen
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create
--
-- -------------------------------------------------------------------


-- -------------------------------------------------------------------
-- cdm_procedure_occurrence
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_procedure_occurrence
(
    person_id                   integer     not null ,
    procedure_concept_id        integer     not null ,
    procedure_date              DATE      not null ,
    procedure_datetime          timestamp           ,
    procedure_type_concept_id   integer     not null ,
    modifier_concept_id         integer              ,
    quantity                    integer              ,
    provider_id                 integer              ,
    visit_occurrence_id         integer              ,
    visit_detail_id             integer              ,
    procedure_source_value      varchar             ,
    procedure_source_concept_id integer              ,
    modifier_source_value      varchar              ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

-- -------------------------------------------------------------------
-- Rules 1-4
-- lk_procedure_mapped
-- -------------------------------------------------------------------

INSERT INTO public.cdm_procedure_occurrence
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS procedure_concept_id,
    CAST(src.start_datetime AS DATE)            AS procedure_date,
    src.start_datetime                          AS procedure_datetime,
    src.type_concept_id                         AS procedure_type_concept_id,
    0                                           AS modifier_concept_id,
    CAST(src.quantity AS integer)                 AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS procedure_source_value,
    src.source_concept_id                       AS procedure_source_concept_id,
    CAST(NULL AS varchar)                        AS modifier_source_value,
    --
    CONCAT('procedure.', src.unit_id)           AS unit_id,
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
    src.target_domain_id = 'Procedure'
;

-- -------------------------------------------------------------------
-- Rule 5
-- lk_observation_mapped, possible DRG codes
-- -------------------------------------------------------------------

INSERT INTO public.cdm_procedure_occurrence
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS procedure_concept_id,
    CAST(src.start_datetime AS DATE)            AS procedure_date,
    src.start_datetime                          AS procedure_datetime,
    src.type_concept_id                         AS procedure_type_concept_id,
    0                                           AS modifier_concept_id,
    CAST(NULL AS integer)                         AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS procedure_source_value,
    src.source_concept_id                       AS procedure_source_concept_id,
    CAST(NULL AS varchar)                        AS modifier_source_value,
    --
    CONCAT('procedure.', src.unit_id)           AS unit_id,
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
    src.target_domain_id = 'Procedure'
;

-- -------------------------------------------------------------------
-- Rule 6
-- lk_specimen_mapped, small part of specimen is mapped to Procedure
-- -------------------------------------------------------------------

INSERT INTO public.cdm_procedure_occurrence
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS procedure_concept_id,
    CAST(src.start_datetime AS DATE)            AS procedure_date,
    src.start_datetime                          AS procedure_datetime,
    src.type_concept_id                         AS procedure_type_concept_id,
    0                                           AS modifier_concept_id,
    CAST(NULL AS integer)                         AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS procedure_source_value,
    src.source_concept_id                       AS procedure_source_concept_id,
    CAST(NULL AS varchar)                        AS modifier_source_value,
    --
    CONCAT('procedure.', src.unit_id)           AS unit_id,
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
    src.target_domain_id = 'Procedure'
;


-- -------------------------------------------------------------------
-- Rule 7
-- lk_chartevents_mapped, a part of chartevents table is mapped to Procedure
-- -------------------------------------------------------------------

INSERT INTO public.cdm_procedure_occurrence
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS procedure_concept_id,
    CAST(src.start_datetime AS DATE)            AS procedure_date,
    src.start_datetime                          AS procedure_datetime,
    src.type_concept_id                         AS procedure_type_concept_id,
    0                                           AS modifier_concept_id,
    CAST(NULL AS integer)                         AS quantity,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS procedure_source_value,
    src.source_concept_id                       AS procedure_source_concept_id,
    CAST(NULL AS varchar)                        AS modifier_source_value,
    --
    CONCAT('procedure.', src.unit_id)           AS unit_id,
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
    src.target_domain_id = 'Procedure'
;

ALTER TABLE cdm_procedure_occurrence add procedure_occurrence_id serial;

DROP SEQUENCE cdm_procedure_occurrence_procedure_occurrence_id_seq CASCADE; -- This may give error when loading into a SQL Client about not existing but it will by the time this is run