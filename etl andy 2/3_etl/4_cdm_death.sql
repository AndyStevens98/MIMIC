-- -------------------------------------------------------------------
-- Andy Stevens, GTRI, 2023
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate cdm_death table
--
-- Dependencies: run after
--      st_core.sql,
--      cdm_person.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- lk_death_adm_mapped
-- Rule 1, admissionss
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_etl.lk_death_adm_mapped AS
SELECT DISTINCT
    src.subject_id,
    FIRST_VALUE(src.deathtime) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC
    )                                   AS deathtime,
    FIRST_VALUE(src.dischtime) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC
    )                                   AS dischtime,
    32817                               AS type_concept_id, -- OMOP4976890 EHR
    --
    'admissions'                        AS unit_id,
    src.load_table_id                   AS load_table_id,
    FIRST_VALUE(src.load_row_id) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC
    )                                   AS load_row_id,
    FIRST_VALUE(src.trace_id) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC
    )                                   AS trace_id
FROM
    mimiciv_hosp.src_admissions src -- adm
WHERE
    src.deathtime IS NOT NULL
;

-- -------------------------------------------------------------------
-- cdm_death
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE mimiciv_etl.cdm_death
(
    person_id               INTEGER     not null ,
    death_date              DATE      not null ,
    death_datetime          TIMESTAMP           ,
    death_type_concept_id   INTEGER     not null ,
    cause_concept_id        INTEGER              ,
    cause_source_value      VARCHAR             ,
    cause_source_concept_id INTEGER              ,
    --
    unit_id                       VARCHAR,
    load_table_id                 VARCHAR,
    load_row_id                   VARCHAR,
    trace_id                      VARCHAR
)
;

INSERT INTO mimiciv_etl.cdm_death
SELECT
    per.person_id       AS person_id,
    (CASE
        WHEN src.deathtime IS NOT NULL AND src.deathtime <= src.dischtime THEN src.deathtime
        WHEN src.deathtime IS NOT NULL THEN src.dischtime
        WHEN pat.dod IS NOT NULL THEN pat.dod
     END)::DATE                              AS death_date,
    (CASE
        WHEN src.deathtime IS NOT NULL AND src.deathtime <= src.dischtime THEN src.deathtime
        WHEN src.deathtime IS NOT NULL THEN src.dischtime
        WHEN pat.dod IS NOT NULL THEN pat.dod
     END)::TIMESTAMP                                   AS death_datetime,
    src.type_concept_id                     AS death_type_concept_id,
    0                                       AS cause_concept_id,
    NULL::VARCHAR                           AS cause_source_value,
    0                                       AS cause_source_concept_id,
    --
    CONCAT('death.', src.unit_id)           AS unit_id,
    src.load_table_id       AS load_table_id,
    src.load_row_id         AS load_row_id,
    src.trace_id            AS trace_id
FROM
    mimiciv_etl.lk_death_adm_mapped src
INNER JOIN
    mimiciv_etl.cdm_person per
        ON src.subject_id = per.person_id
LEFT JOIN --Need to fix this to actually work
    mimiciv_hosp.src_patients as pat
        ON src.subject_id = pat.subject_id
;

DROP TABLE IF EXISTS mimiciv_etl.lk_death_adm_mapped;