-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_person table
--
-- Dependencies: run after st_core.sql
-- on Demo: 12.4 sec
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize "create or replace"
-- mimiciv_etl.cdm_person;
--
-- negative unique id from md5(gen_random_uuid()::text)
--
-- loaded custom mapping:
--      gcpt_ethnicity_to_concept -> mimiciv_per_ethnicity
--
-- Why don't we want to use subject_id as person_id and hadm_id as visit_occurrence_id?
--      ask analysts
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- tmp_subject_ethnicity
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.tmp_subject_race AS
SELECT DISTINCT
    src.subject_id                      AS subject_id,
    FIRST_VALUE(src.race) OVER (
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC)     AS race_first
FROM
    mimiciv_hosp.src_admissions src
;

-- -------------------------------------------------------------------
-- lk_pat_ethnicity_concept
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.lk_pat_race_concept AS
SELECT DISTINCT
    src.race_first          AS source_code,
    vc.concept_id           AS source_concept_id,
    vc.vocabulary_id        AS source_vocabulary_id,
    vc1.concept_id          AS target_concept_id,
    vc1.vocabulary_id       AS target_vocabulary_id -- look here to distinguish Race and Ethnicity
FROM
    mimiciv_etl.tmp_subject_race src
LEFT JOIN
    -- gcpt_ethnicity_to_concept -> mimiciv_per_ethnicity
    mimiciv_voc.voc_concept vc
        ON UPPER(vc.concept_code) = UPPER(src.race_first) -- do the custom mapping
        AND vc.domain_id IN ('Race', 'Ethnicity')
LEFT JOIN
    mimiciv_voc.voc_concept_relationship cr1
        ON  cr1.concept_id_1 = vc.concept_id
        AND cr1.relationship_id = 'Maps to'
LEFT JOIN
    mimiciv_voc.voc_concept vc1
        ON  cr1.concept_id_2 = vc1.concept_id
        AND vc1.invalid_reason IS NULL
        AND vc1.standard_concept = 'S'
;

-- -------------------------------------------------------------------
-- cdm_person
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE mimiciv_etl.cdm_person
(
    person_id                   INTEGER     not null ,
    gender_concept_id           INTEGER     not null ,
    year_of_birth               INTEGER     not null ,
    month_of_birth              INTEGER              ,
    day_of_birth                INTEGER              ,
    birth_datetime              TIMESTAMP           ,
    race_concept_id             INTEGER     not null,
    ethnicity_concept_id        INTEGER     not null,
    location_id                 INTEGER              ,
    provider_id                 INTEGER              ,
    care_site_id                INTEGER              ,
    person_source_value         VARCHAR             ,
    gender_source_value         VARCHAR             ,
    gender_source_concept_id    INTEGER              ,
    race_source_value           VARCHAR             ,
    race_source_concept_id      INTEGER              ,
    ethnicity_source_value      VARCHAR             ,
    ethnicity_source_concept_id INTEGER              ,
    --
    unit_id                       VARCHAR,
    load_table_id                 VARCHAR,
    load_row_id                   VARCHAR,
    trace_id                      VARCHAR
)
;

INSERT INTO mimiciv_etl.cdm_person
SELECT
    p.subject_id                        AS person_id,
    CASE
        WHEN p.gender = 'F' THEN 8532 -- FEMALE
        WHEN p.gender = 'M' THEN 8507 -- MALE
        ELSE 0
    END                                 AS gender_concept_id,
    p.anchor_year                       AS year_of_birth,
    CAST(NULL AS INTEGER)               AS month_of_birth,
    CAST(NULL AS INTEGER)               AS day_of_birth,
    CAST(NULL AS TIMESTAMP)              AS birth_datetime,
    COALESCE(
        CASE
            WHEN map_race.target_vocabulary_id = 'Race'
                THEN map_race.target_concept_id
        END, 0)                               AS race_concept_id,
    COALESCE(
        CASE
            WHEN map_race.target_vocabulary_id = 'Ethnicity'
                THEN map_race.target_concept_id
        END, 0)                       AS ethnicity_concept_id,
    CAST(NULL AS INTEGER)             AS location_id,
    CAST(NULL AS INTEGER)             AS provider_id,
    CAST(NULL AS INTEGER)             AS care_site_id,
    CAST(p.subject_id AS VARCHAR)    AS person_source_value,
    p.gender                        AS gender_source_value,
    0                               AS gender_source_concept_id,
    CASE
        WHEN map_race.target_vocabulary_id = 'Race'
            THEN race.race_first
    END                             AS race_source_value,
    COALESCE(
        CASE
            WHEN map_race.target_vocabulary_id = 'Race'
                THEN map_race.source_concept_id
        END, 0)                     AS race_source_concept_id,
    CASE
        WHEN map_race.target_vocabulary_id = 'Ethnicity'
            THEN race.race_first
    END                             AS ethnicity_source_value,
    COALESCE(
        CASE
            WHEN map_race.target_vocabulary_id = 'Ethnicity'
                THEN map_race.source_concept_id
        END, 0)                     AS ethnicity_source_concept_id,
    --
    'person.patients'               AS unit_id,
    p.load_table_id                 AS load_table_id,
    p.load_row_id                   AS load_row_id,
    p.trace_id                      AS trace_id
FROM
    mimiciv_hosp.src_patients p
LEFT JOIN
    mimiciv_etl.tmp_subject_race race
        ON  p.subject_id = race.subject_id
LEFT JOIN
    mimiciv_etl.lk_pat_race_concept map_race
        ON  race.race_first = map_race.source_code
;


-- -------------------------------------------------------------------
-- cleanup
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS mimiciv_etl.tmp_subject_race;
DROP TABLE IF EXISTS mimiciv_etl.lk_pat_race_concept;