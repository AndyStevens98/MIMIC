-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_care_site table
--
-- Dependencies: run after st_core.sql
-- on Demo:
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize "create or replace"
--
-- negative unique id from md5(gen_random_uuid()::text)
--
-- custom mapping:
--      gcpt_care_site -> mimiciv_cs_place_of_service
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- lk_trans_careunit_clean
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.lk_trans_careunit_clean AS
SELECT
    src.careunit                        AS source_code,
    src.load_table_id                   AS load_table_id,
    0                                   AS load_row_id,
    MIN(src.trace_id)                   AS trace_id
FROM
    mimiciv_hosp.src_transfers src
WHERE
    src.careunit IS NOT NULL
GROUP BY
    careunit,
    load_table_id
;



-- -------------------------------------------------------------------
-- cdm_care_site
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.cdm_care_site
(
    care_site_name                VARCHAR               ,
    place_of_service_concept_id   INTEGER                ,
    location_id                   INTEGER                ,
    care_site_source_value        VARCHAR               ,
    place_of_service_source_value VARCHAR               ,
    --
    unit_id                       VARCHAR,
    load_table_id                 VARCHAR,
    load_row_id                   INTEGER,
    trace_id                      VARCHAR
)
;

INSERT INTO mimiciv_etl.cdm_care_site
SELECT
    src.source_code                     AS care_site_name,
    vc2.concept_id                      AS place_of_service_concept_id,
    1                                   AS location_id,  -- hard-coded BIDMC
    src.source_code                     AS care_site_source_value,
    src.source_code                     AS place_of_service_source_value,
    'care_site.transfers'               AS unit_id,
    src.load_table_id                   AS load_table_id,
    src.load_row_id                     AS load_row_id,
    src.trace_id                        AS trace_id
FROM
    mimiciv_etl.lk_trans_careunit_clean src
LEFT JOIN
    mimiciv_voc.voc_concept vc
        ON  vc.concept_code = src.source_code
        AND vc.vocabulary_id = 'mimiciv_cs_place_of_service' -- gcpt_care_site
LEFT JOIN
    mimiciv_voc.voc_concept_relationship vcr
        ON  vc.concept_id = vcr.concept_id_1
        AND vcr.relationship_id = 'Maps to'
LEFT JOIN
    mimiciv_voc.voc_concept vc2
        ON vc2.concept_id = vcr.concept_id_2
        AND vc2.standard_concept = 'S'
        AND vc2.invalid_reason IS NULL
;

ALTER TABLE mimiciv_etl.cdm_care_site add care_site_id serial;

DROP SEQUENCE mimiciv_etl.cdm_care_site_care_site_id_seq CASCADE; -- This may give error when loading into a SQL Client about not existing but it will by the time this is run

DROP TABLE IF EXISTS mimiciv_etl.lk_trans_careunit_clean;