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
-- for Condition_occurrence
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_diagnoses_icd
-- -------------------------------------------------------------------

CREATE TABLE public.src_diagnoses_icd AS
SELECT
    subject_id      AS subject_id,
    hadm_id         AS hadm_id,
    seq_num         AS seq_num,
    icd_code        AS icd_code,
    icd_version     AS icd_version,
    --
    'diagnoses_icd'                     AS load_table_id
FROM
    public.diagnoses_icd
;

-- -------------------------------------------------------------------
-- for Measurement
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_services
-- -------------------------------------------------------------------

CREATE TABLE public.src_services AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    transfertime                        AS transfertime,
    prev_service                        AS prev_service,
    curr_service                        AS curr_service,
    --
    'services'                          AS load_table_id
FROM
    public.services
;

-- -------------------------------------------------------------------
-- src_labevents
-- -------------------------------------------------------------------

CREATE TABLE public.src_labevents AS
SELECT
    labevent_id                         AS labevent_id,
    subject_id                          AS subject_id,
    charttime                           AS charttime,
    hadm_id                             AS hadm_id,
    itemid                              AS itemid,
    valueuom                            AS valueuom,
    value                               AS value,
    flag                                AS flag,
    ref_range_lower                     AS ref_range_lower,
    ref_range_upper                     AS ref_range_upper,
    --
    'labevents'                         AS load_table_id
FROM
    public.labevents
;

-- -------------------------------------------------------------------
-- src_d_labitems
-- -------------------------------------------------------------------

CREATE TABLE public.src_d_labitems AS
SELECT
    itemid                              AS itemid,
    label                               AS label,
    fluid                               AS fluid,
    category                            AS category,
    loinc_code                          AS loinc_code,
    --
    'd_labitems'                        AS load_table_id
FROM
    public.d_labitems
;


-- -------------------------------------------------------------------
-- for Procedure
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_procedures_icd
-- -------------------------------------------------------------------

CREATE TABLE public.src_procedures_icd AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    icd_code        AS icd_code,
    icd_version     AS icd_version,
    --
    'procedures_icd'                    AS load_table_id
FROM
    public.procedures_icd
;

-- -------------------------------------------------------------------
-- src_hcpcsevents
-- -------------------------------------------------------------------

CREATE TABLE public.src_hcpcsevents AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    hcpcs_cd                            AS hcpcs_cd,
    seq_num                             AS seq_num,
    short_description                   AS short_description,
    --
    'hcpcsevents'                       AS load_table_id
FROM
    public.hcpcsevents
;


-- -------------------------------------------------------------------
-- src_drgcodes
-- -------------------------------------------------------------------

CREATE TABLE public.src_drgcodes AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    drg_code                            AS drg_code,
    description                         AS description,
    --
    'drgcodes'                       AS load_table_id
FROM
    public.drgcodes
;

-- -------------------------------------------------------------------
-- src_prescriptions
-- -------------------------------------------------------------------

CREATE TABLE public.src_prescriptions AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    pharmacy_id                         AS pharmacy_id,
    starttime                           AS starttime,
    stoptime                            AS stoptime,
    drug_type                           AS drug_type,
    drug                                AS drug,
    gsn                                 AS gsn,
    ndc                                 AS ndc,
    prod_strength                       AS prod_strength,
    form_rx                             AS form_rx,
    dose_val_rx                         AS dose_val_rx,
    dose_unit_rx                        AS dose_unit_rx,
    form_val_disp                       AS form_val_disp,
    form_unit_disp                      AS form_unit_disp,
    doses_per_24_hrs                    AS doses_per_24_hrs,
    route                               AS route,
    --
    'prescriptions'                     AS load_table_id
FROM
    public.prescriptions
;


-- -------------------------------------------------------------------
-- src_microbiologyevents
-- -------------------------------------------------------------------

CREATE TABLE public.src_microbiologyevents AS
SELECT
    microevent_id               AS microevent_id,
    subject_id                  AS subject_id,
    hadm_id                     AS hadm_id,
    chartdate                   AS chartdate,
    charttime                   AS charttime, -- usage: COALESCE(charttime, chartdate)
    spec_itemid                 AS spec_itemid, -- d_micro, type of specimen taken. If no grouth, then all other fields is null
    spec_type_desc              AS spec_type_desc, -- for reference
    test_itemid                 AS test_itemid, -- d_micro, what test is taken, goes to measurement
    test_name                   AS test_name, -- for reference
    org_itemid                  AS org_itemid, -- d_micro, what bacteria have grown
    org_name                    AS org_name, -- for reference
    ab_itemid                   AS ab_itemid, -- d_micro, antibiotic tested on the bacteria
    ab_name                     AS ab_name, -- for reference
    dilution_comparison         AS dilution_comparison, -- operator sign
    dilution_value              AS dilution_value, -- numeric value
    interpretation              AS interpretation, -- bacteria's degree of resistance to the antibiotic
    --
    'microbiologyevents'                AS load_table_id
FROM
    public.microbiologyevents
;

-- -------------------------------------------------------------------
-- src_d_micro
-- d_micro no longer exists after MIMIC IV 0.4 (08/2020 release)
-- This will create src_d_micro from the microbiology events to make this process work
-- -------------------------------------------------------------------

CREATE TABLE public.d_micro AS
-- specimen category
SELECT
    spec_itemid             AS itemid,
    spec_type_desc          AS label,
    'SPECIMEN'              AS category
FROM
    public.microbiologyevents
WHERE
    spec_itemid is not null
GROUP BY
    spec_itemid,
    spec_type_desc
UNION ALL
-- microtest category
SELECT
    test_itemid             AS itemid,
    test_name               AS label,
    'MICROTEST'             AS category
FROM
    public.microbiologyevents
WHERE
    test_itemid is not null
GROUP BY
    test_itemid,
    test_name
UNION ALL
-- organism category
SELECT
    org_itemid              AS itemid,
    org_name                AS label,
    'ORGANISM'              AS category
FROM
    public.microbiologyevents
WHERE
    org_itemid is not null
GROUP BY
    org_itemid,
    org_name
UNION ALL
-- anitbiotic category
SELECT
    ab_itemid               AS itemid,
    ab_name                 AS label,
    'ANTIBIOTIC'            AS category
FROM
    public.microbiologyevents
WHERE
    ab_itemid is not null
GROUP BY
    ab_itemid,
    ab_name
;

CREATE TABLE public.src_d_micro AS
SELECT
    itemid                      AS itemid, -- numeric ID
    label                       AS label, -- source_code for custom mapping
    category                    AS category,
    --
    'd_micro'                   AS load_table_id
FROM
    public.d_micro
;

-- -------------------------------------------------------------------
-- src_pharmacy
-- -------------------------------------------------------------------

CREATE TABLE public.src_pharmacy AS
SELECT
    pharmacy_id                         AS pharmacy_id,
    medication                          AS medication,
    -- hadm_id                             AS hadm_id,
    -- subject_id                          AS subject_id,
    -- starttime                           AS starttime,
    -- stoptime                            AS stoptime,
    -- route                               AS route,
    --
    'pharmacy'                          AS load_table_id
FROM
    public.pharmacy
;

