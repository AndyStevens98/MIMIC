--------------------------------------
--------------------------------------
-- Indexes for all MIMIC-IV modules --
--------------------------------------
--------------------------------------

----------
-- hosp --
----------

SET search_path TO mimiciv_hosp;

-- admissions

DROP INDEX IF EXISTS admissions_idx01;
CREATE INDEX admissions_idx01
  ON src_admissions (admittime, dischtime, deathtime);

-- d_icd_diagnoses

DROP INDEX IF EXISTS D_ICD_DIAG_idx02;
CREATE INDEX D_ICD_DIAG_idx02
  ON src_D_ICD_DIAGNOSES (LONG_TITLE);

-- D_ICD_PROCEDURES

DROP INDEX IF EXISTS D_ICD_PROC_idx02;
CREATE INDEX D_ICD_PROC_idx02
  ON src_D_ICD_PROCEDURES (LONG_TITLE);

-- drgcodes

DROP INDEX IF EXISTS drgcodes_idx01;
CREATE INDEX drgcodes_idx01
  ON src_drgcodes (drg_code, drg_type);

DROP INDEX IF EXISTS drgcodes_idx02;
CREATE INDEX drgcodes_idx02
  ON src_drgcodes (description, drg_severity);

-- d_labitems

DROP INDEX IF EXISTS d_labitems_idx01;
CREATE INDEX d_labitems_idx01
  ON src_d_labitems (label, fluid, category);

-- emar_detail

DROP INDEX IF EXISTS emar_detail_idx01;
CREATE INDEX emar_detail_idx01
  ON src_emar_detail (pharmacy_id);

DROP INDEX IF EXISTS emar_detail_idx02;
CREATE INDEX emar_detail_idx02
  ON src_emar_detail (product_code);

DROP INDEX IF EXISTS emar_detail_idx03;
CREATE INDEX emar_detail_idx03
  ON src_emar_detail (route, site, side);

DROP INDEX IF EXISTS EMAR_DET_idx04;
CREATE INDEX EMAR_DET_idx04
  ON src_EMAR_DETAIL (PRODUCT_DESCRIPTION);

-- emar

DROP INDEX IF EXISTS emar_idx01;
CREATE INDEX emar_idx01
  ON src_emar (poe_id);

DROP INDEX IF EXISTS emar_idx02;
CREATE INDEX emar_idx02
  ON src_emar (pharmacy_id);

DROP INDEX IF EXISTS emar_idx03;
CREATE INDEX emar_idx03
  ON src_emar (charttime, scheduletime, storetime);

DROP INDEX IF EXISTS emar_idx04;
CREATE INDEX emar_idx04
  ON src_emar (medication);

-- HCPCSEVENTS

DROP INDEX IF EXISTS HCPCSEVENTS_idx04;
CREATE INDEX HCPCSEVENTS_idx04
  ON src_HCPCSEVENTS (SHORT_DESCRIPTION);

-- labevents

DROP INDEX IF EXISTS labevents_idx01;
CREATE INDEX labevents_idx01
  ON src_labevents (charttime, storetime);

DROP INDEX IF EXISTS labevents_idx02;
CREATE INDEX labevents_idx02
  ON src_labevents (specimen_id);

-- microbiologyevents

DROP INDEX IF EXISTS microbiologyevents_idx01;
CREATE INDEX microbiologyevents_idx01
  ON src_microbiologyevents (chartdate, charttime, storedate, storetime);

DROP INDEX IF EXISTS microbiologyevents_idx02;
CREATE INDEX microbiologyevents_idx02
  ON src_microbiologyevents (spec_itemid, test_itemid, org_itemid, ab_itemid);

DROP INDEX IF EXISTS microbiologyevents_idx03;
CREATE INDEX microbiologyevents_idx03
  ON src_microbiologyevents (micro_specimen_id);

-- patients
DROP INDEX IF EXISTS patients_idx01;
CREATE INDEX patients_idx01
  ON src_patients (anchor_age);

DROP INDEX IF EXISTS patients_idx02;
CREATE INDEX patients_idx02
  ON src_patients (anchor_year);

-- pharmacy

DROP INDEX IF EXISTS pharmacy_idx01;
CREATE INDEX pharmacy_idx01
  ON src_pharmacy (poe_id);

DROP INDEX IF EXISTS pharmacy_idx02;
CREATE INDEX pharmacy_idx02
  ON src_pharmacy (starttime, stoptime);

DROP INDEX IF EXISTS pharmacy_idx03;
CREATE INDEX pharmacy_idx03
  ON src_pharmacy (medication);

DROP INDEX IF EXISTS pharmacy_idx04;
CREATE INDEX pharmacy_idx04
  ON src_pharmacy (route);

-- poe

DROP INDEX IF EXISTS poe_idx01;
CREATE INDEX poe_idx01
  ON src_poe (order_type);

-- prescriptions

DROP INDEX IF EXISTS prescriptions_idx01;
CREATE INDEX prescriptions_idx01
  ON src_prescriptions (starttime, stoptime);

-- transfers

DROP INDEX IF EXISTS transfers_idx01;
CREATE INDEX transfers_idx01
  ON src_transfers (hadm_id);

DROP INDEX IF EXISTS transfers_idx02;
CREATE INDEX transfers_idx02
  ON src_transfers (intime);

DROP INDEX IF EXISTS transfers_idx03;
CREATE INDEX transfers_idx03
  ON src_transfers (careunit);

---------
-- icu --
---------

SET search_path TO mimiciv_icu;

-- chartevents

DROP INDEX IF EXISTS chartevents_idx01;
CREATE INDEX chartevents_idx01
  ON src_chartevents (charttime, storetime);

-- datetimeevents

DROP INDEX IF EXISTS datetimeevents_idx01;
CREATE INDEX datetimeevents_idx01
  ON src_datetimeevents (charttime, storetime);

DROP INDEX IF EXISTS datetimeevents_idx02;
CREATE INDEX datetimeevents_idx02
  ON src_datetimeevents (value);

-- d_items

DROP INDEX IF EXISTS d_items_idx01;
CREATE INDEX d_items_idx01
  ON src_d_items (label, abbreviation);

DROP INDEX IF EXISTS d_items_idx02;
CREATE INDEX d_items_idx02
  ON src_d_items (category);

-- icustays

DROP INDEX IF EXISTS icustays_idx01;
CREATE INDEX icustays_idx01
  ON src_icustays (first_careunit, last_careunit);

DROP INDEX IF EXISTS icustays_idx02;
CREATE INDEX icustays_idx02
  ON src_icustays (intime, outtime);

-- inputevents

DROP INDEX IF EXISTS inputevents_idx01;
CREATE INDEX inputevents_idx01
  ON src_inputevents (starttime, endtime);

DROP INDEX IF EXISTS inputevents_idx02;
CREATE INDEX inputevents_idx02
  ON src_inputevents (ordercategorydescription);

-- outputevents

DROP INDEX IF EXISTS outputevents_idx01;
CREATE INDEX outputevents_idx01
  ON src_outputevents (charttime, storetime);

-- procedureevents

DROP INDEX IF EXISTS procedureevents_idx01;
CREATE INDEX procedureevents_idx01
  ON src_procedureevents (starttime, endtime);

DROP INDEX IF EXISTS procedureevents_idx02;
CREATE INDEX procedureevents_idx02
  ON src_procedureevents (ordercategoryname);
