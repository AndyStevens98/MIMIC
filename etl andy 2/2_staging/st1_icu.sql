-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
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
-- src_caregiver
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_caregiver AS
    SELECT
        *,
        'caregiver'                         AS load_table_id,
        md5(gen_random_uuid()::text)        AS load_row_id,
        json_build_object(
            'caregiver_id', caregiver_id
        ) #>> '{}'                          AS trace_id
    FROM
        mimiciv_icu.caregiver;


-- -------------------------------------------------------------------
-- src_icustays
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_icustays AS
    SELECT
        *,
        'icustays'                          AS load_table_id,
        md5(gen_random_uuid()::text)        AS load_row_id,
        json_build_object(
            'subject_id', subject_id,
            'hadm_id', hadm_id,
            'stay_id', stay_id
        ) #>> '{}'                          AS trace_id
    FROM
        mimiciv_icu.icustays;

-- -------------------------------------------------------------------
-- src_ingredientevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_ingredientevents AS
    SELECT
        *,
        'ingredientevents'                          AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'subject_id', subject_id,
            'hadm_id', hadm_id,
            'stay_id', stay_id,
            'caregiver_id', caregiver_id,
            'starttime', starttime,
            'itemid', itemid,
            'orderid', orderid
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_icu.ingredientevents;

-- -------------------------------------------------------------------
-- src_inputevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_inputevents AS
    SELECT
        *,
        'inputevents'                               AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'itemid', itemid,
            'orderid', orderid
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_icu.inputevents;

-- -------------------------------------------------------------------
-- src_outputevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_outputevents AS
    SELECT
        *,
        'outputevents'                               AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'stay_id', stay_id,
            'charttime', charttime,
            'itemid', itemid
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_icu.outputevents;

-- -------------------------------------------------------------------
-- src_procedureevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_procedureevents AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    stay_id                             AS stay_id,
    caregiver_id                        AS caregiver_id,
    starttime                           AS starttime,
    endtime                             AS endtime,
    storetime                           AS storetime,
    itemid                              AS itemid,
    value                               AS value,
    valueuom                            AS valueuom,
    location                            AS location,
    locationcategory                    AS locationcategory,
    orderid                             AS orderid,
    linkorderid                         AS linkorderid,
    ordercategoryname                   AS ordercategoryname,
    ordercategorydescription            AS ordercategorydescription,
    patientweight                       AS patientweight,
    isopenbag                           AS isopenbag,
    continueinnextdept                  AS continueinnextdept,
    statusdescription                   AS statusdescription,
    originalamount                      AS originalamount,
    originalrate                        AS originalrate,
    --
    'procedureevents'                   AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'starttime', starttime
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_icu.procedureevents
;

-- -------------------------------------------------------------------
-- src_d_items
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_d_items AS
SELECT
    itemid                              AS itemid,
    label                               AS label,
    abbreviation                        AS abbreviation,
    linksto                             AS linksto,
    category                            AS category,
    unitname                            AS unitname,
    param_type                          AS param_type,
    lownormalvalue                      AS lownormalvalue,
    highnormalvalue                     AS highnormalvalue,

    'd_items'                           AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'itemid', itemid,
        'linksto', linksto
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_icu.d_items
;

-- -------------------------------------------------------------------
-- src_datetimeevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_icu.src_datetimeevents AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    stay_id                             AS stay_id,
    caregiver_id                        AS caregiver_id,
    charttime                           AS charttime,
    storetime                           AS storetime,
    itemid                              AS itemid,
    value                               AS value,
    valueuom                            AS valueuom,
    warning                             AS warning,
    --
    'datetimeevents'                    AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'stay_id', stay_id,
        'charttime', charttime
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_icu.datetimeevents
;


CREATE TABLE mimiciv_icu.src_chartevents AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    stay_id                             AS stay_id,
    caregiver_id                        AS caregiver_id,
    charttime                           AS charttime,
    storetime                           AS storetime,
    itemid                              AS itemid,
    value                               AS value,
    valuenum                            AS valuenum,
    valueuom                            AS valueuom,
    warning                             AS warning,
    --
    'chartevents'                       AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'stay_id', stay_id,
        'charttime', charttime
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_icu.chartevents
;
