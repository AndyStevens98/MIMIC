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
-- transfers.stay_id - does not exist in Demo, but is described in the online Documentation
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_patients
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_patients AS
SELECT
    subject_id                          AS subject_id,
    anchor_year                         AS anchor_year,
    anchor_age                          AS anchor_age,
    anchor_year_group                   AS anchor_year_group,
    gender                              AS gender,
    dod                                 AS dod,
    --
    'patients'                          AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.patients
;

-- -------------------------------------------------------------------
-- src_admissions
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_admissions AS
SELECT
    hadm_id                             AS hadm_id, -- PK
    subject_id                          AS subject_id,
    admittime                           AS admittime,
    dischtime                           AS dischtime,
    deathtime                           AS deathtime,
    admission_type                      AS admission_type,
    admit_provider_id                   AS admit_provider_id,
    admission_location                  AS admission_location,
    discharge_location                  AS discharge_location,
    race                                AS race,
    ethnicity                           AS ethnicity,
    edregtime                           AS edregtime,
    edouttime                           AS edouttime,
    insurance                           AS insurance,
    marital_status                      AS marital_status,
    language                            AS language,
    hospital_expire_flag                AS hospital_expire_flag,
    --
    'admissions'                        AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.admissions
;

-- -------------------------------------------------------------------
-- src_transfers
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_transfers AS
SELECT
    transfer_id                         AS transfer_id,
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    careunit                            AS careunit,
    intime                              AS intime,
    outtime                             AS outtime,
    eventtype                           AS eventtype,
    --
    'transfers'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'transfer_id', transfer_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.transfers
;


-- -------------------------------------------------------------------
-- for Condition_occurrence
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_diagnoses_icd
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_diagnoses_icd AS
SELECT
    subject_id      AS subject_id,
    hadm_id         AS hadm_id,
    seq_num         AS seq_num,
    icd_code        AS icd_code,
    icd_version     AS icd_version,
    --
    'diagnoses_icd'                     AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'hadm_id', hadm_id,
        'seq_num', seq_num
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.diagnoses_icd
;

-- -------------------------------------------------------------------
-- for Measurement
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_services
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_services AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    transfertime                        AS transfertime,
    prev_service                        AS prev_service,
    curr_service                        AS curr_service,
    --
    'services'                          AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'transfertime', transfertime
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.services
;

-- -------------------------------------------------------------------
-- src_labevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_labevents AS
SELECT
    labevent_id                         AS labevent_id,
    subject_id                          AS subject_id,
    charttime                           AS charttime,
    storetime                           AS storetime,
    hadm_id                             AS hadm_id,
    specimen_id                         AS specimen_id,
    itemid                              AS itemid,
    order_provider_id                   AS order_provider_id,
    valueuom                            AS valueuom,
    valuenum                            AS valuenum,
    value                               AS value,
    flag                                AS flag,
    priority                            AS priority,
    comments                            AS comments,
    ref_range_lower                     AS ref_range_lower,
    ref_range_upper                     AS ref_range_upper,
    --
    'labevents'                         AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'labevent_id', labevent_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.labevents
;

-- -------------------------------------------------------------------
-- src_d_labitems
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_d_labitems AS
SELECT
    itemid                              AS itemid,
    label                               AS label,
    fluid                               AS fluid,
    category                            AS category,
    --
    'd_labitems'                        AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'itemid', itemid
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.d_labitems
;


-- -------------------------------------------------------------------
-- for Procedure
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- src_procedures_icd
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_procedures_icd AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    seq_num                             AS seq_num,
    chartdate                           AS chartdate,
    icd_code                            AS icd_code,
    icd_version                         AS icd_version,
    --
    'procedures_icd'                    AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'seq_num', seq_num
        'icd_code', icd_code,
        'icd_version', icd_version
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.procedures_icd
;

-- -------------------------------------------------------------------
-- src_hcpcsevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_hcpcsevents AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    chartdate                           AS chartdate,
    hcpcs_cd                            AS hcpcs_cd,
    seq_num                             AS seq_num,
    short_description                   AS short_description,
    --
    'hcpcsevents'                       AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'hcpcs_cd', hcpcs_cd,
        'seq_num', seq_num
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.hcpcsevents
;


-- -------------------------------------------------------------------
-- src_drgcodes
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_drgcodes AS
SELECT
    hadm_id                                 AS hadm_id,
    subject_id                              AS subject_id,
    drg_type                                AS drg_type,
    drg_code                                AS drg_code,
    description                             AS description,
    drg_severity                            AS drg_severity,
    drg_mortality                           AS drg_mortality,
    --
    'drgcodes'                              AS load_table_id,
    md5(gen_random_uuid()::text)            AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'drg_type', drg_type,
        'drg_code', COALESCE(drg_code, '')
    ) #>> '{}'                              AS trace_id
FROM
    mimiciv_hosp.drgcodes
;

-- -------------------------------------------------------------------
-- src_prescriptions
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_prescriptions AS
SELECT
    hadm_id                             AS hadm_id,
    subject_id                          AS subject_id,
    pharmacy_id                         AS pharmacy_id,
    poe_id                              AS poe_id,
    poe_seq                             AS poe_seq,
    order_provider_id                   AS order_provider_id,
    starttime                           AS starttime,
    stoptime                            AS stoptime,
    drug_type                           AS drug_type,
    drug                                AS drug,
    formulary_drug_cd                   AS formulary_drug_cd,
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
    'prescriptions'                     AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'pharmacy_id', pharmacy_id,
        'starttime', starttime
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.prescriptions
;


-- -------------------------------------------------------------------
-- src_microbiologyevents
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_microbiologyevents AS
SELECT
    microevent_id                               AS microevent_id,
    subject_id                                  AS subject_id,
    hadm_id                                     AS hadm_id,
    micro_specimen_id                           AS micro_specimen_id,
    order_provider_id                           AS order_provider_id,
    chartdate                                   AS chartdate,
    charttime                                   AS charttime, -- usage: COALESCE(charttime, chartdate)
    spec_itemid                                 AS spec_itemid, -- d_micro, type of specimen taken. If no grouth, then all other fields is null
    spec_type_desc                              AS spec_type_desc, -- for reference,
    test_seq                                    AS test_seq,
    storedate                                   AS storedate,
    storetime                                   AS storetime,
    test_itemid                                 AS test_itemid, -- d_micro, what test is taken, goes to measurement
    test_name                                   AS test_name, -- for reference
    org_itemid                                  AS org_itemid, -- d_micro, what bacteria have grown
    org_name                                    AS org_name, -- for reference
    isolate_num                                 AS isolate_num,
    quantity                                    AS quantity,
    ab_itemid                                   AS ab_itemid, -- d_micro, antibiotic tested on the bacteria
    ab_name                                     AS ab_name, -- for reference
    dilution_text                               AS dilution_text,
    dilution_comparison                         AS dilution_comparison, -- operator sign
    dilution_value                              AS dilution_value, -- numeric value
    interpretation                              AS interpretation, -- bacteria's degree of resistance to the antibiotic
    comments                                    AS comments,
    --
    'microbiologyevents'                        AS load_table_id,
    md5(gen_random_uuid()::text)                AS load_row_id,
    json_build_object(
        'subject_id', subject_id,
        'hadm_id', hadm_id,
        'microevent_id', microevent_id
    ) #>> '{}'                                   AS trace_id
FROM
   mimiciv_hosp.microbiologyevents
;

-- -------------------------------------------------------------------
-- src_pharmacy
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_pharmacy AS
SELECT
    subject_id                          AS subject_id,
    hadm_id                             AS hadm_id,
    pharmacy_id                         AS pharmacy_id,
    poe_id                              AS poe_id,
    starttime                           AS starttime,
    stoptime                            AS stoptime,
    medication                          AS medication,
    proc_type                           AS proc_type,
    status                              AS status,
    entertime                           AS entertime,
    verifiedtime                        AS verifiedtime,
    route                               AS route,
    frequency                           AS frequency,
    disp_sched                          AS disp_sched,
    infusion_type                       AS infusion_type,
    sliding_scale                       AS sliding_scale,
    lockout_interval                    AS lockout_interval,
    basal_rate                          AS basal_rate,
    one_hr_max                          AS one_hr_max,
    doses_per_24_hrs                    AS doses_per_24_hrs,
    duration                            AS duration,
    duration_interval                   AS duration_interval,
    expiration_value                    AS expiration_value,
    expiration_unit                     AS expiration_unit,
    expirationdate                      AS expirationdate,
    dispensation                        AS dispensation,
    fill_quantity                       AS fill_quantity,
    --
    'pharmacy'                          AS load_table_id,
    md5(gen_random_uuid()::text)        AS load_row_id,
    json_build_object(
        'pharmacy_id', pharmacy_id
    ) #>> '{}'                          AS trace_id
FROM
    mimiciv_hosp.pharmacy
;

-- -------------------------------------------------------------------
-- src_d_hcpcs
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_d_hcpcs AS
    SELECT
        *,
        'd_hcpcs'                                   AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'code', code
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.d_hcpcs;

-- -------------------------------------------------------------------
-- src_d_icd_diagnoses
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_d_icd_diagnoses AS
    SELECT
        *,
        'd_icd_diagnoses'                           AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'icd_code', icd_code,
            'icd_version', icd_version
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.d_icd_diagnoses;

-- -------------------------------------------------------------------
-- src_d_icd_procedures
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_d_icd_procedures AS
    SELECT
        *,
        'd_icd_procedures'                           AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'icd_code', icd_code,
            'icd_version', icd_version
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.d_icd_procedures;

-- -------------------------------------------------------------------
-- src_emar
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_emar AS
    SELECT
        *,
        'emar'                                      AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'emar_id', emar_id
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.emar;

-- -------------------------------------------------------------------
-- src_emar_detail
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_emar_detail AS
    SELECT
        *,
        'emar_detail'                               AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'emar_id', emar_id,
            'parent_field_ordinal', parent_field_ordinal
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.emar_detail;

-- -------------------------------------------------------------------
-- src_omr
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_omr AS
    SELECT
        *,
        'omr'                                       AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'subject_id', subject_id,
            'chartdate', chartdate,
            'seq_num', seq_num,
            'result_name', result_name
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.omr;

-- -------------------------------------------------------------------
-- src_poe
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_poe AS
    SELECT
        *,
        'poe'                                       AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'poe_id', poe_id
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.poe;

-- -------------------------------------------------------------------
-- src_poe_detail
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_poe_detail AS
    SELECT
        *,
        'poe_detail'                                AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'poe_id', poe_id,
            'field_name', field_name
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.poe_detail;

-- -------------------------------------------------------------------
-- src_provider
-- -------------------------------------------------------------------

CREATE TABLE mimiciv_hosp.src_provider AS
    SELECT
        *,
        'provider'                                  AS load_table_id,
        md5(gen_random_uuid()::text)                AS load_row_id,
        json_build_object(
            'provider_id', provider_id
        ) #>> '{}'                                  AS trace_id
    FROM
        mimiciv_hosp.provider;

