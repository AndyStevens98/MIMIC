-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
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

CREATE TABLE public.lk_death_adm_mapped AS
SELECT DISTINCT
    src.subject_id,
    FIRST_VALUE(src.deathtime) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime
    )                                   AS deathtime,
    FIRST_VALUE(src.dischtime) OVER(
        PARTITION BY src.subject_id
        ORDER BY src.admittime
    )                                   AS dischtime,
    32817                               AS type_concept_id, -- OMOP4976890 EHR
    --
    'admissions'                        AS unit_id,
    src.load_table_id                   AS load_table_id
FROM
    public.src_admissions src -- adm
WHERE
    src.deathtime IS NOT NULL
;

-- -------------------------------------------------------------------
-- cdm_death
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_death
(
    person_id               integer     not null ,
    death_date              DATE      not null ,
    death_datetime          timestamp           ,
    death_type_concept_id   integer     not null ,
    cause_concept_id        integer              ,
    cause_source_value      varchar             ,
    cause_source_concept_id integer              ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

INSERT INTO public.cdm_death
SELECT
    per.person_id       AS person_id,
    CAST(CASE
            WHEN src.deathtime <= src.dischtime THEN src.deathtime
            ELSE src.dischtime
        END
     AS DATE)                              AS death_date,
    CASE
        WHEN src.deathtime <= src.dischtime THEN src.deathtime
        ELSE src.dischtime
    END                                     AS death_datetime,
    src.type_concept_id                     AS death_type_concept_id,
    0                                       AS cause_concept_id,
    CAST(NULL AS varchar)                    AS cause_source_value,
    0                                       AS cause_source_concept_id,
    --
    CONCAT('death.', src.unit_id)           AS unit_id,
    src.load_table_id       AS load_table_id
FROM
    public.lk_death_adm_mapped src
INNER JOIN
    public.cdm_person per
        ON CAST(src.subject_id AS varchar) = per.person_source_value
;