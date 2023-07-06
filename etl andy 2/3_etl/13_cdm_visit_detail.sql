-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
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
-- negative unique id from md5(gen_random_uuid()::text)
--
-- src.callout - is there any derived table in MIMIC IV?
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_visit_detail
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE mimiciv_etl.cdm_visit_detail
(
    visit_detail_id                     INTEGER     not null ,
    person_id                           INTEGER     not null ,
    visit_detail_concept_id             INTEGER     not null ,
    visit_detail_start_date             DATE        not null ,
    visit_detail_start_datetime         TIMESTAMP            ,
    visit_detail_end_date               DATE        not null ,
    visit_detail_end_datetime           TIMESTAMP            ,
    visit_detail_type_concept_id        INTEGER     not null , -- detail! -- this typo still exists in v.5.3.1(???)
    provider_id                         INTEGER              ,
    care_site_id                        INTEGER              ,
    admitting_source_concept_id         INTEGER              ,
    discharge_to_concept_id             INTEGER              ,
    preceding_visit_detail_id           INTEGER              ,
    visit_detail_source_value           VARCHAR              ,
    visit_detail_source_concept_id      INTEGER              , -- detail! -- this typo still exists in v.5.3.1(???)
    admitting_source_value              VARCHAR              ,
    discharge_to_source_value           VARCHAR              ,
    visit_detail_parent_id              INTEGER              ,
    visit_occurrence_id                 INTEGER     not null ,
    --
    unit_id                             VARCHAR              ,
    load_table_id                       VARCHAR              ,
    load_row_id                         TEXT                 ,
    trace_id                            VARCHAR
)
;

-- -------------------------------------------------------------------
-- Rule 1. transfers
-- Rule 2. services
-- -------------------------------------------------------------------




INSERT INTO mimiciv_etl.cdm_visit_detail
SELECT
    src.visit_detail_id                     AS visit_detail_id,
    per.person_id                           AS person_id,
    COALESCE(vdc.target_concept_id, 0)      AS visit_detail_concept_id,
                                            -- see source value in care_site.care_site_source_value
    src.start_datetime::DATE                AS visit_start_date,
    src.start_datetime                      AS visit_start_datetime,
    src.end_datetime::DATE                  AS visit_end_date,
    src.end_datetime                        AS visit_end_datetime,
    32817                                   AS visit_detail_type_concept_id,   -- EHR   Type Concept    Standard
    NULL::INTEGER                           AS provider_id,
    cs.care_site_id                         AS care_site_id,

    CASE
        WHEN src.admission_location IS NOT NULL
            THEN COALESCE(la.target_concept_id, 0)
    END                                     AS admitting_source_concept_id,
    CASE
        WHEN src.discharge_location IS NOT NULL
            THEN COALESCE(ld.target_concept_id, 0)
    END                                     AS discharge_to_concept_id,

    src.preceding_visit_detail_id           AS preceding_visit_detail_id,
    src.source_value                        AS visit_detail_source_value,
    COALESCE(vdc.source_concept_id, 0)      AS visit_detail_source_concept_id,
    src.admission_location                  AS admitting_source_value,
    src.discharge_location                  AS discharge_to_source_value,
    NULL::INTEGER                     AS visit_detail_parent_id,
    vis.visit_occurrence_id                 AS visit_occurrence_id,
    --
    CONCAT('visit_detail.', src.unit_id)    AS unit_id,
    src.load_table_id                 AS load_table_id,
    src.load_row_id                   AS load_row_id,
    src.trace_id                      AS trace_id
FROM
    mimiciv_etl.lk_visit_detail_prev_next src
INNER JOIN
    mimiciv_etl.cdm_person per
        ON src.subject_id::VARCHAR = per.person_source_value
INNER JOIN
    mimiciv_etl.cdm_visit_occurrence vis
        ON  vis.visit_source_value =
            CONCAT(src.subject_id::VARCHAR, '|',
                COALESCE(src.hadm_id::VARCHAR, src.date_id::VARCHAR))
LEFT JOIN
    mimiciv_etl.cdm_care_site cs
        ON cs.care_site_source_value = src.current_location
LEFT JOIN
    mimiciv_etl.lk_visit_concept vdc
        ON vdc.source_code = src.current_location
LEFT JOIN
    mimiciv_etl.lk_visit_concept la
        ON la.source_code = src.admission_location
LEFT JOIN
    mimiciv_etl.lk_visit_concept ld
        ON ld.source_code = src.discharge_location
;
