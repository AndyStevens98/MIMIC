-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Populate first part of lookups for cdm_visit_occurrence and cdm_visit_detail
-- to use it for lk_meas_* tables and then vise versa
--
-- Dependencies: run after
--      st_core.sql
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
--
-- There were logic for post mortem donors in MIMIC III based on patients' diagnosis
-- It is not implemented here
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- lk_admissions_clean
--
-- All to visit_occurrence, to create visits with hadm_id
-- Then there will be added visits without hadm_id
-- ER admissions to visit_detail too
-- -------------------------------------------------------------------

CREATE TABLE public.lk_admissions_clean AS
SELECT
    src.subject_id                                  AS subject_id,
    src.hadm_id                                     AS hadm_id,
    CASE
        WHEN src.edregtime < src.admittime THEN src.edregtime
        ELSE src.admittime
    END                                             AS start_datetime, -- the earliest of
    src.dischtime                                   AS end_datetime,
    src.admission_type                              AS admission_type, -- current location
    src.admission_location                          AS admission_location, -- to hospital
    src.discharge_location                          AS discharge_location, -- from hospital
    CASE
        WHEN src.edregtime IS NULL THEN FALSE
        ELSE TRUE
    END                                             AS is_er_admission, -- create visit_detail if TRUE
    --
    'admissions'                    AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.src_admissions src -- adm
;

-- -------------------------------------------------------------------
-- lk_transfers_clean
--
-- Rule 1.
-- from transfers without discharges to visit_detail
-- -------------------------------------------------------------------

CREATE TABLE public.lk_transfers_clean AS
SELECT
    src.subject_id                                  AS subject_id,
    COALESCE(src.hadm_id, vis.hadm_id)              AS hadm_id,
    CAST(src.intime AS DATE)                        AS date_id,
    src.transfer_id                                 AS transfer_id,
    src.intime                                      AS start_datetime,
    src.outtime                                     AS end_datetime,
    src.careunit                                    AS current_location, -- find prev and next for adm and disch location
    --
    'transfers'                     AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.src_transfers src
LEFT JOIN
    public.lk_admissions_clean vis -- associate transfers with admissions according to
        ON vis.subject_id = src.subject_id
        AND src.intime BETWEEN vis.start_datetime AND vis.end_datetime
        AND src.hadm_id IS NULL
WHERE
    src.eventtype != 'discharge' -- these are not useful
;

-- -------------------------------------------------------------------
-- lk_services_clean
--
-- Rule 3.
-- SERVICES information
-- -------------------------------------------------------------------

CREATE TABLE public.lk_services_clean AS
SELECT
    src.subject_id                                  AS subject_id,
    src.hadm_id                                     AS hadm_id,
    src.transfertime                                AS start_datetime,
    LEAD(src.transfertime) OVER (
        PARTITION BY src.subject_id, src.hadm_id
        ORDER BY src.transfertime
    )                                               AS end_datetime,
    src.curr_service                                AS curr_service,
    src.prev_service                                AS prev_service,
    LAG(src.curr_service) OVER (
        PARTITION BY src.subject_id, src.hadm_id
        ORDER BY src.transfertime
    )                                               AS lag_service,
                                -- to double-check that the services sequence is still consistent
    --
    'services'                      AS unit_id,
    src.load_table_id               AS load_table_id
FROM
    public.src_services src
;
