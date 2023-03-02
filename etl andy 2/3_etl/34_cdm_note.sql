-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_note table
--
-- Dependencies: run after st_note.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- -------------------------------------------------------------------

CREATE TABLE cdm_note (
    note_id                         INTEGER NOT NULL,
    person_id                       INTEGER NOT NULL,
    note_date                       DATE NOT NULL,
    note_datetime                   TIMESTAMP,
    note_type_concept_id            INTEGER NOT NULL,
    note_class_concept_id           INTEGER NOT NULL,
    note_title                      VARCHAR,
    note_text                       VARCHAR,
    encoding_concept_id             INTEGER NOT NULL,
    language_concept_id             INTEGER NOT NULL,
    provider_id                     INTEGER,
    visit_occurrence_id             INTEGER,
    visit_detail_id                 INTEGER,
    note_source_value               VARCHAR.
    --
    unit_id                         VARCHAR,
    load_table_id                   VARCHAR,
    load_row_id                     INTEGER,
    trace_id                        VARCHAR
);