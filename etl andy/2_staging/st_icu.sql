-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate staging tables for cdm dimension tables
--
-- Dependencies: run first after DDL
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_procedureevents
-- -------------------------------------------------------------------

CREATE TABLE public.src_procedureevents AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    stay_id                             AS stay_id,
    itemid                              AS itemid,
    starttime                           AS starttime,
    value                               AS value,
    cancelreason                        AS cancelreason,
    --
    'procedureevents'                   AS load_table_id
FROM
    public.procedureevents
;

-- -------------------------------------------------------------------
-- src_d_items
-- -------------------------------------------------------------------

CREATE TABLE public.src_d_items AS
SELECT
    itemid                              AS itemid,
    label                               AS label,
    linksto                             AS linksto,
    -- abbreviation
    -- category
    -- unitname
    -- param_type
    -- lownormalvalue
    -- highnormalvalue
    --
    'd_items'                           AS load_table_id
FROM
    public.d_items
;

-- -------------------------------------------------------------------
-- src_datetimeevents
-- -------------------------------------------------------------------

CREATE TABLE public.src_datetimeevents AS
SELECT
    subject_id  AS subject_id,
    hadm_id     AS hadm_id,
    stay_id     AS stay_id,
    itemid      AS itemid,
    charttime   AS charttime,
    value       AS value,
    --
    'datetimeevents'                    AS load_table_id
FROM
    public.datetimeevents
;


CREATE TABLE public.src_chartevents AS
SELECT
    subject_id  AS subject_id,
    hadm_id     AS hadm_id,
    stay_id     AS stay_id,
    itemid      AS itemid,
    charttime   AS charttime,
    value       AS value,
    valuenum    AS valuenum,
    valueuom    AS valueuom,
    --
    'chartevents'                       AS load_table_id
FROM
    public.chartevents
;
