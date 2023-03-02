-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Populate cdm_observation_period table
--
-- Dependencies: run after
--      cdm_visit_occurrence
--      all event tables
--      cdm_death
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- TRUNCATE TABLE is not supported, organize create
-- -------------------------------------------------------------------


-- -------------------------------------------------------------------
-- tmp_observation_period_clean
-- -------------------------------------------------------------------

CREATE TABLE public.tmp_observation_period_clean AS
SELECT
    src.person_id               AS person_id,
    MIN(src.visit_start_date)   AS start_date,
    MAX(src.visit_end_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_visit_occurrence src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.condition_start_date)   AS start_date,
    MAX(src.condition_end_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_condition_occurrence src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.procedure_date)   AS start_date,
    MAX(src.procedure_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_procedure_occurrence src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.drug_exposure_start_date)   AS start_date,
    MAX(src.drug_exposure_end_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_drug_exposure src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.device_exposure_start_date)   AS start_date,
    MAX(src.device_exposure_end_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_device_exposure src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.measurement_date)   AS start_date,
    MAX(src.measurement_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_measurement src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.specimen_date)   AS start_date,
    MAX(src.specimen_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_specimen src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.observation_date)   AS start_date,
    MAX(src.observation_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_observation src
GROUP BY
    src.person_id, src.unit_id
;

INSERT INTO public.tmp_observation_period_clean
SELECT
    src.person_id               AS person_id,
    MIN(src.death_date)         AS start_date,
    MAX(src.death_date)         AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.cdm_death src
GROUP BY
    src.person_id, src.unit_id
;


-- -------------------------------------------------------------------
-- tmp_observation_period
-- -------------------------------------------------------------------

CREATE TABLE public.tmp_observation_period AS
SELECT
    src.person_id               AS person_id,
    MIN(src.start_date)   AS start_date,
    MAX(src.end_date)     AS end_date,
    src.unit_id                 AS unit_id
FROM
    public.tmp_observation_period_clean src
GROUP BY
    src.person_id, src.unit_id
;

-- -------------------------------------------------------------------
-- cdm_observation_period
-- -------------------------------------------------------------------

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.cdm_observation_period
(
    person_id                         integer   not null ,
    observation_period_start_date     DATE    not null ,
    observation_period_end_date       DATE    not null ,
    period_type_concept_id            integer   not null ,
    --
    unit_id                       varchar,
    load_table_id                 varchar
)
;

INSERT INTO public.cdm_observation_period
SELECT
    src.person_id                               AS person_id,
    MIN(src.start_date)                         AS observation_period_start_date,
    MAX(src.end_date)                           AS observation_period_end_date,
    32828                                       AS period_type_concept_id,  -- 32828    OMOP4976901 EHR episode record
    --
    'observation_period'                        AS unit_id,
    'event tables'                              AS load_table_id
FROM
    public.tmp_observation_period src
GROUP BY
    src.person_id
;

ALTER TABLE cdm_observation_period add observation_period_id serial;
DROP SEQUENCE cdm_observation_period_observation_period_id_seq CASCADE;

-- -------------------------------------------------------------------
-- cleanup
-- -------------------------------------------------------------------

DROP TABLE IF EXISTS public.tmp_observation_period_clean;
DROP TABLE IF EXISTS public.tmp_observation_period;
