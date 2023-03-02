-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_specimen table
--
-- Dependencies: run after
--      cdm_person.sql,
--      lk_meas_specimen.sql
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Rule 1 specimen from microbiology
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_specimen
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_specimen
(
    specimen_id                 integer     not null ,
    person_id                   integer     not null ,
    specimen_concept_id         integer     not null ,
    specimen_type_concept_id    integer     not null ,
    specimen_date               DATE      not null ,
    specimen_datetime           timestamp           ,
    quantity                    decimal            ,
    unit_concept_id             integer              ,
    anatomic_site_concept_id    integer              ,
    disease_status_concept_id   integer              ,
    specimen_source_id          varchar             ,
    specimen_source_value       varchar             ,
    unit_source_value           varchar             ,
    anatomic_site_source_value  varchar             ,
    disease_status_source_value varchar             ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;


INSERT INTO public.cdm_specimen
SELECT
    src.specimen_id                             AS specimen_id,
    per.person_id                               AS person_id,
    COALESCE(src.target_concept_id, 0)          AS specimen_concept_id,
    32856                                       AS specimen_type_concept_id, -- OMOP4976929 Lab
    CAST(src.start_datetime AS DATE)            AS specimen_date,
    src.start_datetime                          AS specimen_datetime,
    CAST(NULL AS decimal)                       AS quantity,
    CAST(NULL AS integer)                         AS unit_concept_id,
    0                                           AS anatomic_site_concept_id,
    0                                           AS disease_status_concept_id,
    src.spec_itemid                                AS specimen_source_id,
    src.source_code                             AS specimen_source_value,
    CAST(NULL AS varchar)                        AS unit_source_value,
    CAST(NULL AS varchar)                        AS anatomic_site_source_value,
    CAST(NULL AS varchar)                        AS disease_status_source_value,
    --
    CONCAT('specimen.', src.unit_id)    AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.lk_specimen_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
WHERE
    src.target_domain_id = 'Specimen'
;
