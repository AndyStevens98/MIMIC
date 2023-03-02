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
-- src_discharge
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_note.src_discharge AS
SELECT
    *,
    --
    'discharge'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'note_id', note_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_note.discharge
;

-- -------------------------------------------------------------------
-- src_discharge_detail
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_note.src_discharge_detail AS
SELECT
    *,
    --
    'discharge_detail'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'note_id', note_id,
        'field_name', field_name
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_note.discharge_detail
;

-- -------------------------------------------------------------------
-- src_radiology
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_note.src_radiology AS
SELECT
    *,
    --
    'radiology'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'note_id', note_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_note.radiology
;

-- -------------------------------------------------------------------
-- src_radiology_detail
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_note.src_radiology_detail AS
SELECT
    *,
    --
    'radiology_detail'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'note_id', note_id,
        'field_name', field_name,
        'field_ordinal', field_ordinal
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_note.radiology_detail
;

DROP TABLE IF EXISTS mimiciv_note.discharge_detail;
DROP TABLE IF EXISTS mimiciv_note.discharge;
DROP TABLE IF EXISTS mimiciv_note.radiology_detail;
DROP TABLE IF EXISTS mimiciv_note.radiology;