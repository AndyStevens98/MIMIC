-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_visit_detail table
--
-- Dependencies: run after
--      st_core.sql,
--      st_hosp.sql,
--      st_waveform.sql,
--      lk_vis_adm_transfers.sql,
--      cdm_person.sql,
--      cdm_visit_occurrence.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create or replace
-- negative unique id from FARM_FINGERPRINT(GENERATE_UUID())
--
-- src.callout - is there any derived table in MIMIC IV?
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_visit_detail
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_visit_detail
(
    visit_detail_id                    integer     not null ,
    person_id                          integer     not null ,
    visit_detail_concept_id            integer     not null ,
    visit_detail_start_date            DATE      not null ,
    visit_detail_start_datetime        timestamp           ,
    visit_detail_end_date              DATE      not null ,
    visit_detail_end_datetime          timestamp           ,
    visit_detail_type_concept_id       integer     not null ,
    provider_id                        integer              ,
    care_site_id                       integer              ,
    admitted_from_concept_id           integer              ,
    discharged_to_concept_id           integer              ,
    preceding_visit_detail_id          integer              ,
    visit_detail_source_value          varchar             ,
    visit_detail_source_concept_id     integer              ,
    admitted_from_source_value         varchar             ,
    discharged_to_source_value         varchar             ,
    parent_visit_detail_id             integer              ,
    visit_occurrence_id                integer     not null ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

-- -------------------------------------------------------------------
-- Rule 1. transfers
-- Rule 2. services
-- -------------------------------------------------------------------




INSERT INTO public.cdm_visit_detail
SELECT
    src.visit_detail_id                     AS visit_detail_id,
    per.person_id                           AS person_id,
    COALESCE(vdc.target_concept_id, 0)      AS visit_detail_concept_id,
                                            -- see source value in care_site.care_site_source_value
    CAST(src.start_datetime AS DATE)        AS visit_start_date,
    src.start_datetime                      AS visit_start_datetime,
    CAST(src.end_datetime AS DATE)          AS visit_end_date,
    src.end_datetime                        AS visit_end_datetime,
    32817                                   AS visit_detail_type_concept_id,   -- EHR   Type Concept    Standard
    CAST(NULL AS integer)                     AS provider_id,
    cs.care_site_id                         AS care_site_id,

    CASE
        WHEN src.admission_location IS NOT NULL THEN COALESCE(la.target_concept_id, 0)
    END                               AS admitted_from_concept_id,
    CASE
        WHEN src.discharge_location IS NOT NULL THEN COALESCE(ld.target_concept_id, 0)
    END                               AS discharged_to_concept_id,

    src.preceding_visit_detail_id           AS preceding_visit_detail_id,
    src.source_value                        AS visit_detail_source_value,
    COALESCE(vdc.source_concept_id, 0)      AS visit_detail_source_concept_id,
    src.admission_location                  AS admitted_from_source_value,
    src.discharge_location                  AS discharged_to_source_value,
    CAST(NULL AS integer)                     AS parent_visit_detail_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    --
    CONCAT('visit_detail.', src.unit_id)    AS unit_id,
    src.load_table_id                 AS load_table_id
FROM
    public.lk_visit_detail_prev_next src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
INNER JOIN
    public.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(CAST(src.subject_id AS varchar), '|',
                COALESCE(CAST(src.hadm_id AS varchar), CAST(src.date_id AS varchar)))
LEFT JOIN
    public.cdm_care_site cs
        ON cs.care_site_source_value = src.current_location
LEFT JOIN
    public.lk_visit_concept vdc
        ON vdc.source_code = src.current_location
LEFT JOIN
    public.lk_visit_concept la
        ON la.source_code = src.admission_location
LEFT JOIN
    public.lk_visit_concept ld
        ON ld.source_code = src.discharge_location
;
