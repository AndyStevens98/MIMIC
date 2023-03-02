-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_drug_exposure table
--
-- Dependencies: run after
--      lk_drug_prescriptions.sql
--      cdm_person.sql,
--      cdm_visit_occurrence.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_drug_exposure
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_drug_exposure
(
    person_id                     integer       not null ,
    drug_concept_id               integer       not null ,
    drug_exposure_start_date      DATE        not null ,
    drug_exposure_start_datetime  timestamp             ,
    drug_exposure_end_date        DATE        not null ,
    drug_exposure_end_datetime    timestamp             ,
    verbatim_end_date             DATE                 ,
    drug_type_concept_id          integer       not null ,
    stop_reason                   varchar               ,
    refills                       integer                ,
    quantity                      decimal              ,
    days_supply                   integer                ,
    sig                           varchar               ,
    route_concept_id              integer                ,
    lot_number                    varchar               ,
    provider_id                   integer                ,
    visit_occurrence_id           integer                ,
    visit_detail_id               integer                ,
    drug_source_value             varchar               ,
    drug_source_concept_id        integer                ,
    route_source_value            varchar               ,
    dose_unit_source_value        varchar               ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

INSERT INTO public.cdm_drug_exposure
SELECT
    per.person_id                               AS person_id,
    src.target_concept_id                       AS drug_concept_id,
    CAST(src.start_datetime AS DATE)            AS drug_exposure_start_date,
    src.start_datetime                          AS drug_exposure_start_datetime,
    CAST(src.end_datetime AS DATE)              AS drug_exposure_end_date,
    src.end_datetime                            AS drug_exposure_end_datetime,
    CAST(NULL AS DATE)                          AS verbatim_end_date,
    src.type_concept_id                         AS drug_type_concept_id,
    CAST(NULL AS varchar)                        AS stop_reason,
    CAST(NULL AS integer)                         AS refills,
    src.quantity                                AS quantity,
    CAST(NULL AS integer)                         AS days_supply,
    CAST(NULL AS varchar)                        AS sig,
    src.route_concept_id                        AS route_concept_id,
    CAST(NULL AS varchar)                        AS lot_number,
    CAST(NULL AS integer)                         AS provider_id,
    vis.visit_occurrence_id                     AS visit_occurrence_id,
    CAST(NULL AS integer)                         AS visit_detail_id,
    src.source_code                             AS drug_source_value,
    src.source_concept_id                       AS drug_source_concept_id,
    src.route_source_code                       AS route_source_value,
    src.dose_unit_source_code                   AS dose_unit_source_value,
    --
    CONCAT('drug.', src.unit_id)    AS unit_id,
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
    src.target_domain_id = 'Drug'
;


ALTER TABLE cdm_drug_exposure add drug_exposure_id serial;

DROP SEQUENCE cdm_drug_exposure_drug_exposure_id_seq CASCADE;