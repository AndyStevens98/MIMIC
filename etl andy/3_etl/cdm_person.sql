-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
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
-- TRUNCATE TABLE is not supported, organize "create"
-- public.cdm_person;
--
-- negative unique id from FARM_FINGERPRINT(GENERATE_UUID())
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

CREATE TABLE public.tmp_subject_ethnicity AS
SELECT DISTINCT
    src.subject_id                      AS subject_id,
    FIRST_VALUE(src.ethnicity) OVER (
        PARTITION BY src.subject_id
        ORDER BY src.admittime ASC)     AS ethnicity_first
FROM
    public.src_admissions src
;

-- -------------------------------------------------------------------
-- lk_pat_ethnicity_concept
-- -------------------------------------------------------------------

CREATE TABLE public.lk_pat_ethnicity_concept AS
SELECT DISTINCT
    src.ethnicity_first     AS source_code,
    vc.concept_id           AS source_concept_id,
    vc.vocabulary_id        AS source_vocabulary_id,
    vc1.concept_id          AS target_concept_id,
    vc1.vocabulary_id       AS target_vocabulary_id -- look here to distinguish Race and Ethnicity
FROM
    public.tmp_subject_ethnicity src
LEFT JOIN
    -- gcpt_ethnicity_to_concept -> mimiciv_per_ethnicity
    public.voc_concept vc
        ON UPPER(vc.concept_code) = UPPER(src.ethnicity_first) -- do the custom mapping
        AND vc.domain_id IN ('Race', 'Ethnicity')
LEFT JOIN
    public.voc_concept_relationship cr1
        ON  cr1.concept_id_1 = vc.concept_id
        AND cr1.relationship_id = 'Maps to'
LEFT JOIN
    public.voc_concept vc1
        ON  cr1.concept_id_2 = vc1.concept_id
        AND vc1.invalid_reason IS NULL
        AND vc1.standard_concept = 'S'
;

-- -------------------------------------------------------------------
-- cdm_person
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.person
(
    person_id                   integer     not null ,
    gender_concept_id           integer     not null ,
    year_of_birth               integer     not null ,
    month_of_birth              integer              ,
    day_of_birth                integer              ,
    birth_datetime              DATETIME           ,
    race_concept_id             integer     not null,
    ethnicity_concept_id        integer     not null,
    location_id                 integer              ,
    provider_id                 integer              ,
    care_site_id                integer              ,
    person_source_value         varchar             ,
    gender_source_value         varchar             ,
    gender_source_concept_id    integer              ,
    race_source_value           varchar             ,
    race_source_concept_id      integer              ,
    ethnicity_source_value      varchar             ,
    ethnicity_source_concept_id integer
)
;

INSERT INTO public.person
SELECT
    CASE
        WHEN p.gender = 'F' THEN 8532 -- FEMALE
        WHEN p.gender = 'M' THEN 8507 -- MALE
        ELSE 0
    END                             AS gender_concept_id,
    p.anchor_year                   AS year_of_birth,
    CAST(NULL AS integer)             AS month_of_birth,
    CAST(NULL AS integer)             AS day_of_birth,
    CAST(NULL AS DATETIME)          AS birth_datetime,
    COALESCE(
        CASE
            WHEN map_eth.target_vocabulary_id <> 'Ethnicity'
                THEN map_eth.target_concept_id
            ELSE NULL
        END, 0)                               AS race_concept_id,
    COALESCE(
        CASE
            WHEN map_eth.target_vocabulary_id = 'Ethnicity'
                THEN map_eth.target_concept_id
            ELSE NULL
        END, 0)                     AS ethnicity_concept_id,
    CAST(NULL AS integer)             AS location_id,
    CAST(NULL AS integer)             AS provider_id,
    CAST(NULL AS integer)             AS care_site_id,
    CAST(p.subject_id AS varchar)    AS person_source_value,
    p.gender                        AS gender_source_value,
    0                               AS gender_source_concept_id,
    CASE
        WHEN map_eth.target_vocabulary_id <> 'Ethnicity'
            THEN eth.ethnicity_first
        ELSE NULL
    END                             AS race_source_value,
    COALESCE(
        CASE
            WHEN map_eth.target_vocabulary_id <> 'Ethnicity'
                THEN map_eth.source_concept_id
            ELSE NULL
        END, 0)                        AS race_source_concept_id,
    CASE
        WHEN map_eth.target_vocabulary_id = 'Ethnicity'
            THEN eth.ethnicity_first
        ELSE NULL
    END                             AS ethnicity_source_value,
    COALESCE(
        CASE
            WHEN map_eth.target_vocabulary_id = 'Ethnicity'
                THEN map_eth.source_concept_id
            ELSE NULL
        END, 0)                     AS ethnicity_source_concept_id
FROM
    public.src_patients p
LEFT JOIN
    public.tmp_subject_ethnicity eth
        ON  p.subject_id = eth.subject_id
LEFT JOIN
    public.lk_pat_ethnicity_concept map_eth
        ON  eth.ethnicity_first = map_eth.source_code
;


-- -------------------------------------------------------------------
-- cleanup
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS public.tmp_subject_ethnicity;

ALTER TABLE cdm_person add person_id serial;

DROP SEQUENCE cdm_person_person_id_seq CASCADE; -- This may give error when loading into a SQL Client about not existing but it will by the time this is run