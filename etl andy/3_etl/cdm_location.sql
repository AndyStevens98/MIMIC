-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
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

CREATE TABLE public.cdm_location
(
    location_id           integer     not null ,
    address_1             varchar             ,
    address_2             varchar             ,
    city                  varchar             ,
    state                 varchar             ,
    zip                   varchar             ,
    county                varchar             ,
    location_source_value varchar             ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

INSERT INTO public.cdm_location
SELECT
    1                           AS location_id,
    CAST(NULL AS varchar)        AS address_1,
    CAST(NULL AS varchar)        AS address_2,
    CAST(NULL AS varchar)        AS city,
    'MA'                        AS state,
    CAST(NULL AS varchar)        AS zip,
    CAST(NULL AS varchar)        AS county,
    'Beth Israel Hospital'      AS location_source_value,
    --
    'location.null'             AS unit_id,
    'null'                      AS load_table_id
;
