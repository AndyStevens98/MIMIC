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
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_location
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.cdm_location
(
    location_id           INTEGER     not null ,
    address_1             VARCHAR             ,
    address_2             VARCHAR             ,
    city                  VARCHAR             ,
    state                 VARCHAR             ,
    zip                   VARCHAR             ,
    county                VARCHAR             ,
    location_source_value VARCHAR             ,
    --
    unit_id                       VARCHAR,
    load_table_id                 VARCHAR,
    load_row_id                   INTEGER,
    trace_id                      VARCHAR
)
;

INSERT INTO mimiciv_etl.cdm_location
SELECT
    1                               AS location_id,
    '330 Brookline Avenue'          AS address_1,
    CAST(NULL AS VARCHAR)           AS address_2,
    'BOSTON'                        AS city,
    'MA'                            AS state,
    '02215'                         AS zip,
    'Suffolk'                       AS county,
    'Beth Israel Hospital'          AS location_source_value,
    --
    'location.null'                 AS unit_id,
    'null'                          AS load_table_id,
    0                               AS load_row_id,
    CAST(NULL AS VARCHAR)           AS trace_id
;
