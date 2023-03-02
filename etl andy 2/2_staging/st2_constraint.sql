---------------------------
---------------------------
-- Creating Primary Keys --
---------------------------
---------------------------

----------
-- hosp --
----------

-- admissions

ALTER TABLE mimiciv_hosp.src_admissions DROP CONSTRAINT IF EXISTS admissions_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_admissions
ADD CONSTRAINT admissions_pk
  PRIMARY KEY (hadm_id);

-- d_hcpcs

ALTER TABLE mimiciv_hosp.src_d_hcpcs DROP CONSTRAINT IF EXISTS d_hcpcs_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_d_hcpcs
ADD CONSTRAINT d_hcpcs_pk
  PRIMARY KEY (code);

-- diagnoses_icd

ALTER TABLE mimiciv_hosp.src_diagnoses_icd DROP CONSTRAINT IF EXISTS diagnoses_icd_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_diagnoses_icd
ADD CONSTRAINT diagnoses_icd_pk
  PRIMARY KEY (hadm_id, seq_num, icd_code, icd_version);

-- d_icd_diagnoses

ALTER TABLE mimiciv_hosp.src_d_icd_diagnoses DROP CONSTRAINT IF EXISTS d_icd_diagnoses_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_d_icd_diagnoses
ADD CONSTRAINT d_icd_diagnoses_pk
  PRIMARY KEY (icd_code, icd_version);

-- d_icd_procedures

ALTER TABLE mimiciv_hosp.src_d_icd_procedures DROP CONSTRAINT IF EXISTS d_icd_procedures_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_d_icd_procedures
ADD CONSTRAINT d_icd_procedures_pk
  PRIMARY KEY (icd_code, icd_version);

-- d_labitems

ALTER TABLE mimiciv_hosp.src_d_labitems DROP CONSTRAINT IF EXISTS d_labitems_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_d_labitems
ADD CONSTRAINT d_labitems_pk
  PRIMARY KEY (itemid);

-- emar_detail

-- ALTER TABLE mimiciv_hosp.src_emar_detail DROP CONSTRAINT IF EXISTS emar_detail_pk;
-- ALTER TABLE mimiciv_hosp.src_emar_detail
-- ADD CONSTRAINT emar_detail_pk
--   PRIMARY KEY (emar_id, parent_field_ordinal);

-- emar

ALTER TABLE mimiciv_hosp.src_emar DROP CONSTRAINT IF EXISTS emar_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_emar
ADD CONSTRAINT emar_pk
  PRIMARY KEY (emar_id);

-- hcpcsevents

ALTER TABLE mimiciv_hosp.src_hcpcsevents DROP CONSTRAINT IF EXISTS hcpcsevents_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_hcpcsevents
ADD CONSTRAINT hcpcsevents_pk
  PRIMARY KEY (hadm_id, hcpcs_cd, seq_num);

-- labevents

ALTER TABLE mimiciv_hosp.src_labevents DROP CONSTRAINT IF EXISTS labevents_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_labevents
ADD CONSTRAINT labevents_pk
  PRIMARY KEY (labevent_id);

-- microbiologyevents

ALTER TABLE mimiciv_hosp.src_microbiologyevents DROP CONSTRAINT IF EXISTS microbiologyevents_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_microbiologyevents
ADD CONSTRAINT microbiologyevents_pk
  PRIMARY KEY (microevent_id);

-- patients

ALTER TABLE mimiciv_hosp.src_patients DROP CONSTRAINT IF EXISTS patients_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_patients
ADD CONSTRAINT patients_pk
  PRIMARY KEY (subject_id);

-- pharmacy

ALTER TABLE mimiciv_hosp.src_pharmacy DROP CONSTRAINT IF EXISTS pharmacy_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_pharmacy
ADD CONSTRAINT pharmacy_pk
  PRIMARY KEY (pharmacy_id);

-- poe_detail

ALTER TABLE mimiciv_hosp.src_poe_detail DROP CONSTRAINT IF EXISTS poe_detail_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_poe_detail
ADD CONSTRAINT poe_detail_pk
  PRIMARY KEY (poe_id, field_name);

-- poe

ALTER TABLE mimiciv_hosp.src_poe DROP CONSTRAINT IF EXISTS poe_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_poe
ADD CONSTRAINT poe_pk
  PRIMARY KEY (poe_id);

-- prescriptions

ALTER TABLE mimiciv_hosp.src_prescriptions DROP CONSTRAINT IF EXISTS prescriptions_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_prescriptions
ADD CONSTRAINT prescriptions_pk
  PRIMARY KEY (pharmacy_id, drug_type, drug);

-- procedures_icd

ALTER TABLE mimiciv_hosp.src_procedures_icd DROP CONSTRAINT IF EXISTS procedures_icd_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_procedures_icd
ADD CONSTRAINT procedures_icd_pk
  PRIMARY KEY (hadm_id, seq_num, icd_code, icd_version);

-- services

ALTER TABLE mimiciv_hosp.src_services DROP CONSTRAINT IF EXISTS services_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_services
ADD CONSTRAINT services_pk
  PRIMARY KEY (hadm_id, transfertime, curr_service);

---------
-- icu --
---------

-- datetimeevents

ALTER TABLE mimiciv_icu.src_datetimeevents DROP CONSTRAINT IF EXISTS datetimeevents_pk CASCADE;
ALTER TABLE mimiciv_icu.src_datetimeevents
ADD CONSTRAINT datetimeevents_pk
  PRIMARY KEY (stay_id, itemid, charttime);

-- d_items

ALTER TABLE mimiciv_icu.src_d_items DROP CONSTRAINT IF EXISTS d_items_pk CASCADE;
ALTER TABLE mimiciv_icu.src_d_items
ADD CONSTRAINT d_items_pk
  PRIMARY KEY (itemid);

-- icustays

ALTER TABLE mimiciv_icu.src_icustays DROP CONSTRAINT IF EXISTS icustays_pk CASCADE;
ALTER TABLE mimiciv_icu.src_icustays
ADD CONSTRAINT icustays_pk
  PRIMARY KEY (stay_id);

-- inputevents

ALTER TABLE mimiciv_icu.src_inputevents DROP CONSTRAINT IF EXISTS inputevents_pk CASCADE;
ALTER TABLE mimiciv_icu.src_inputevents
ADD CONSTRAINT inputevents_pk
  PRIMARY KEY (orderid, itemid);

-- outputevents

ALTER TABLE mimiciv_icu.src_outputevents DROP CONSTRAINT IF EXISTS outputevents_pk CASCADE;
ALTER TABLE mimiciv_icu.src_outputevents
ADD CONSTRAINT outputevents_pk
  PRIMARY KEY (stay_id, charttime, itemid);

-- procedureevents

ALTER TABLE mimiciv_icu.src_procedureevents DROP CONSTRAINT IF EXISTS procedureevents_pk CASCADE;
ALTER TABLE mimiciv_icu.src_procedureevents
ADD CONSTRAINT procedureevents_pk
  PRIMARY KEY (orderid);

---------
-- note --
---------

-- discharge

ALTER TABLE mimiciv_note.src_discharge DROP CONSTRAINT IF EXISTS discharge_pk CASCADE;
ALTER TABLE mimiciv_note.src_discharge
ADD CONSTRAINT discharge_pk
  PRIMARY KEY (note_id);

-- discharge_detail

ALTER TABLE mimiciv_note.src_discharge_detail DROP CONSTRAINT IF EXISTS discharge_detail_pk CASCADE;
ALTER TABLE mimiciv_note.src_discharge_detail
ADD CONSTRAINT discharge_detail_pk
  PRIMARY KEY (note_id, field_name, field_ordinal);

-- radiology

ALTER TABLE mimiciv_note.src_radiology DROP CONSTRAINT IF EXISTS radiology_pk CASCADE;
ALTER TABLE mimiciv_note.src_radiology
ADD CONSTRAINT radiology_pk
  PRIMARY KEY (note_id);

-- radiology_detail

ALTER TABLE mimiciv_note.src_radiology_detail DROP CONSTRAINT IF EXISTS radiology_detail_pk CASCADE;
ALTER TABLE mimiciv_note.src_radiology_detail
ADD CONSTRAINT radiology_detail_pk
  PRIMARY KEY (note_id, field_name, field_ordinal);

---------------------------
---------------------------
-- Creating Foreign Keys --
---------------------------
---------------------------

----------
-- hosp --
----------

-- admissions

ALTER TABLE mimiciv_hosp.src_admissions DROP CONSTRAINT IF EXISTS admissions_patients_fk;
ALTER TABLE mimiciv_hosp.src_admissions
ADD CONSTRAINT admissions_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

-- diagnoses_icd

ALTER TABLE mimiciv_hosp.src_diagnoses_icd DROP CONSTRAINT IF EXISTS diagnoses_icd_patients_fk;
ALTER TABLE mimiciv_hosp.src_diagnoses_icd
ADD CONSTRAINT diagnoses_icd_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_diagnoses_icd DROP CONSTRAINT IF EXISTS diagnoses_icd_admissions_fk;
ALTER TABLE mimiciv_hosp.src_diagnoses_icd
ADD CONSTRAINT diagnoses_icd_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- drgcodes

ALTER TABLE mimiciv_hosp.src_drgcodes DROP CONSTRAINT IF EXISTS drgcodes_patients_fk;
ALTER TABLE mimiciv_hosp.src_drgcodes
ADD CONSTRAINT drgcodes_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_drgcodes DROP CONSTRAINT IF EXISTS drgcodes_admissions_fk;
ALTER TABLE mimiciv_hosp.src_drgcodes
ADD CONSTRAINT drgcodes_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- emar_detail

ALTER TABLE mimiciv_hosp.src_emar_detail DROP CONSTRAINT IF EXISTS emar_detail_patients_fk;
ALTER TABLE mimiciv_hosp.src_emar_detail
ADD CONSTRAINT emar_detail_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_emar_detail DROP CONSTRAINT IF EXISTS emar_detail_emar_fk;
ALTER TABLE mimiciv_hosp.src_emar_detail
ADD CONSTRAINT emar_detail_emar_fk
  FOREIGN KEY (emar_id)
  REFERENCES mimiciv_hosp.src_emar (emar_id);

-- emar

ALTER TABLE mimiciv_hosp.src_emar DROP CONSTRAINT IF EXISTS emar_patients_fk;
ALTER TABLE mimiciv_hosp.src_emar
ADD CONSTRAINT emar_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_emar DROP CONSTRAINT IF EXISTS emar_admissions_fk;
ALTER TABLE mimiciv_hosp.src_emar
ADD CONSTRAINT emar_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- hcpcsevents

ALTER TABLE mimiciv_hosp.src_hcpcsevents DROP CONSTRAINT IF EXISTS hcpcsevents_patients_fk;
ALTER TABLE mimiciv_hosp.src_hcpcsevents
ADD CONSTRAINT hcpcsevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_hcpcsevents DROP CONSTRAINT IF EXISTS hcpcsevents_admissions_fk;
ALTER TABLE mimiciv_hosp.src_hcpcsevents
ADD CONSTRAINT hcpcsevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_hosp.src_hcpcsevents DROP CONSTRAINT IF EXISTS hcpcsevents_d_hcpcs_fk;
ALTER TABLE mimiciv_hosp.src_hcpcsevents
ADD CONSTRAINT hcpcsevents_d_hcpcs_fk
  FOREIGN KEY (hcpcs_cd)
  REFERENCES mimiciv_hosp.src_d_hcpcs (code);

-- labevents

ALTER TABLE mimiciv_hosp.src_labevents DROP CONSTRAINT IF EXISTS labevents_patients_fk;
ALTER TABLE mimiciv_hosp.src_labevents
ADD CONSTRAINT labevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_labevents DROP CONSTRAINT IF EXISTS labevents_d_labitems_fk;
ALTER TABLE mimiciv_hosp.src_labevents
ADD CONSTRAINT labevents_d_labitems_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_hosp.src_d_labitems (itemid);

-- microbiologyevents

ALTER TABLE mimiciv_hosp.src_microbiologyevents DROP CONSTRAINT IF EXISTS microbiologyevents_patients_fk;
ALTER TABLE mimiciv_hosp.src_microbiologyevents
ADD CONSTRAINT microbiologyevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_microbiologyevents DROP CONSTRAINT IF EXISTS microbiologyevents_admissions_fk;
ALTER TABLE mimiciv_hosp.src_microbiologyevents
ADD CONSTRAINT microbiologyevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- pharmacy

ALTER TABLE mimiciv_hosp.src_pharmacy DROP CONSTRAINT IF EXISTS pharmacy_patients_fk;
ALTER TABLE mimiciv_hosp.src_pharmacy
ADD CONSTRAINT pharmacy_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_pharmacy DROP CONSTRAINT IF EXISTS pharmacy_admissions_fk;
ALTER TABLE mimiciv_hosp.src_pharmacy
ADD CONSTRAINT pharmacy_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- poe_detail

ALTER TABLE mimiciv_hosp.src_poe_detail DROP CONSTRAINT IF EXISTS poe_detail_patients_fk;
ALTER TABLE mimiciv_hosp.src_poe_detail
ADD CONSTRAINT poe_detail_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_poe_detail DROP CONSTRAINT IF EXISTS poe_detail_poe_fk;
ALTER TABLE mimiciv_hosp.src_poe_detail
ADD CONSTRAINT poe_detail_poe_fk
  FOREIGN KEY (poe_id)
  REFERENCES mimiciv_hosp.src_poe (poe_id);

-- poe

ALTER TABLE mimiciv_hosp.src_poe DROP CONSTRAINT IF EXISTS poe_patients_fk;
ALTER TABLE mimiciv_hosp.src_poe
ADD CONSTRAINT poe_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_poe DROP CONSTRAINT IF EXISTS poe_admissions_fk;
ALTER TABLE mimiciv_hosp.src_poe
ADD CONSTRAINT poe_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- prescriptions

ALTER TABLE mimiciv_hosp.src_prescriptions DROP CONSTRAINT IF EXISTS prescriptions_patients_fk;
ALTER TABLE mimiciv_hosp.src_prescriptions
ADD CONSTRAINT prescriptions_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_prescriptions DROP CONSTRAINT IF EXISTS prescriptions_admissions_fk;
ALTER TABLE mimiciv_hosp.src_prescriptions
ADD CONSTRAINT prescriptions_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- procedures_icd

ALTER TABLE mimiciv_hosp.src_procedures_icd DROP CONSTRAINT IF EXISTS procedures_icd_patients_fk;
ALTER TABLE mimiciv_hosp.src_procedures_icd
ADD CONSTRAINT procedures_icd_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_procedures_icd DROP CONSTRAINT IF EXISTS procedures_icd_admissions_fk;
ALTER TABLE mimiciv_hosp.src_procedures_icd
ADD CONSTRAINT procedures_icd_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- services

ALTER TABLE mimiciv_hosp.src_services DROP CONSTRAINT IF EXISTS services_patients_fk;
ALTER TABLE mimiciv_hosp.src_services
ADD CONSTRAINT services_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_hosp.src_services DROP CONSTRAINT IF EXISTS services_admissions_fk;
ALTER TABLE mimiciv_hosp.src_services
ADD CONSTRAINT services_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- transfers

ALTER TABLE mimiciv_hosp.src_transfers DROP CONSTRAINT IF EXISTS transfers_pk CASCADE;
ALTER TABLE mimiciv_hosp.src_transfers
ADD CONSTRAINT transfers_pk
  PRIMARY KEY (transfer_id);

-- transfers

ALTER TABLE mimiciv_hosp.src_transfers DROP CONSTRAINT IF EXISTS transfers_patients_fk;
ALTER TABLE mimiciv_hosp.src_transfers
ADD CONSTRAINT transfers_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);


---------
-- icu --
---------

-- chartevents

ALTER TABLE mimiciv_icu.src_chartevents DROP CONSTRAINT IF EXISTS chartevents_patients_fk;
ALTER TABLE mimiciv_icu.src_chartevents
ADD CONSTRAINT chartevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_chartevents DROP CONSTRAINT IF EXISTS chartevents_admissions_fk;
ALTER TABLE mimiciv_icu.src_chartevents
ADD CONSTRAINT chartevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_icu.src_chartevents DROP CONSTRAINT IF EXISTS chartevents_icustays_fk;
ALTER TABLE mimiciv_icu.src_chartevents
ADD CONSTRAINT chartevents_icustays_fk
  FOREIGN KEY (stay_id)
  REFERENCES mimiciv_icu.src_icustays (stay_id);

ALTER TABLE mimiciv_icu.src_chartevents DROP CONSTRAINT IF EXISTS chartevents_d_items_fk;
ALTER TABLE mimiciv_icu.src_chartevents
ADD CONSTRAINT chartevents_d_items_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_icu.src_d_items (itemid);

-- datetimeevents

ALTER TABLE mimiciv_icu.src_datetimeevents DROP CONSTRAINT IF EXISTS datetimeevents_patients_fk;
ALTER TABLE mimiciv_icu.src_datetimeevents
ADD CONSTRAINT datetimeevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_datetimeevents DROP CONSTRAINT IF EXISTS datetimeevents_admissions_fk;
ALTER TABLE mimiciv_icu.src_datetimeevents
ADD CONSTRAINT datetimeevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_icu.src_datetimeevents DROP CONSTRAINT IF EXISTS datetimeevents_icustays_fk;
ALTER TABLE mimiciv_icu.src_datetimeevents
ADD CONSTRAINT datetimeevents_icustays_fk
  FOREIGN KEY (stay_id)
  REFERENCES mimiciv_icu.src_icustays (stay_id);

ALTER TABLE mimiciv_icu.src_datetimeevents DROP CONSTRAINT IF EXISTS datetimeevents_d_items_fk;
ALTER TABLE mimiciv_icu.src_datetimeevents
ADD CONSTRAINT datetimeevents_d_items_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_icu.src_d_items (itemid);

-- icustays

ALTER TABLE mimiciv_icu.src_icustays DROP CONSTRAINT IF EXISTS icustays_patients_fk;
ALTER TABLE mimiciv_icu.src_icustays
ADD CONSTRAINT icustays_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_icustays DROP CONSTRAINT IF EXISTS icustays_admissions_fk;
ALTER TABLE mimiciv_icu.src_icustays
ADD CONSTRAINT icustays_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- inputevents

ALTER TABLE mimiciv_icu.src_inputevents DROP CONSTRAINT IF EXISTS inputevents_patients_fk;
ALTER TABLE mimiciv_icu.src_inputevents
ADD CONSTRAINT inputevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_inputevents DROP CONSTRAINT IF EXISTS inputevents_admissions_fk;
ALTER TABLE mimiciv_icu.src_inputevents
ADD CONSTRAINT inputevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_icu.src_inputevents DROP CONSTRAINT IF EXISTS inputevents_icustays_fk;
ALTER TABLE mimiciv_icu.src_inputevents
ADD CONSTRAINT inputevents_icustays_fk
  FOREIGN KEY (stay_id)
  REFERENCES mimiciv_icu.src_icustays (stay_id);

ALTER TABLE mimiciv_icu.src_inputevents DROP CONSTRAINT IF EXISTS inputevents_d_items_fk;
ALTER TABLE mimiciv_icu.src_inputevents
ADD CONSTRAINT inputevents_d_items_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_icu.src_d_items (itemid);

-- outputevents

ALTER TABLE mimiciv_icu.src_outputevents DROP CONSTRAINT IF EXISTS outputevents_patients_fk;
ALTER TABLE mimiciv_icu.src_outputevents
ADD CONSTRAINT outputevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_outputevents DROP CONSTRAINT IF EXISTS outputevents_admissions_fk;
ALTER TABLE mimiciv_icu.src_outputevents
ADD CONSTRAINT outputevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_icu.src_outputevents DROP CONSTRAINT IF EXISTS outputevents_icustays_fk;
ALTER TABLE mimiciv_icu.src_outputevents
ADD CONSTRAINT outputevents_icustays_fk
  FOREIGN KEY (stay_id)
  REFERENCES mimiciv_icu.src_icustays (stay_id);

ALTER TABLE mimiciv_icu.src_outputevents DROP CONSTRAINT IF EXISTS outputevents_d_items_fk;
ALTER TABLE mimiciv_icu.src_outputevents
ADD CONSTRAINT outputevents_d_items_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_icu.src_d_items (itemid);

-- procedureevents

ALTER TABLE mimiciv_icu.src_procedureevents DROP CONSTRAINT IF EXISTS procedureevents_patients_fk;
ALTER TABLE mimiciv_icu.src_procedureevents
ADD CONSTRAINT procedureevents_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_icu.src_procedureevents DROP CONSTRAINT IF EXISTS procedureevents_admissions_fk;
ALTER TABLE mimiciv_icu.src_procedureevents
ADD CONSTRAINT procedureevents_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

ALTER TABLE mimiciv_icu.src_procedureevents DROP CONSTRAINT IF EXISTS procedureevents_icustays_fk;
ALTER TABLE mimiciv_icu.src_procedureevents
ADD CONSTRAINT procedureevents_icustays_fk
  FOREIGN KEY (stay_id)
  REFERENCES mimiciv_icu.src_icustays (stay_id);

ALTER TABLE mimiciv_icu.src_procedureevents DROP CONSTRAINT IF EXISTS procedureevents_d_items_fk;
ALTER TABLE mimiciv_icu.src_procedureevents
ADD CONSTRAINT procedureevents_d_items_fk
  FOREIGN KEY (itemid)
  REFERENCES mimiciv_icu.src_d_items (itemid);


---------
-- note --
---------

-- discharge

ALTER TABLE mimiciv_note.src_discharge DROP CONSTRAINT IF EXISTS discharge_patients_fk;
ALTER TABLE mimiciv_note.src_discharge
ADD CONSTRAINT discharge_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_note.src_discharge DROP CONSTRAINT IF EXISTS discharge_admissions_fk;
ALTER TABLE mimiciv_note.src_discharge
ADD CONSTRAINT discharge_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- discharge_detail

ALTER TABLE mimiciv_note.src_discharge_detail DROP CONSTRAINT IF EXISTS discharge_detail_discharge_fk;
ALTER TABLE mimiciv_note.src_discharge_detail
ADD CONSTRAINT discharge_detail_discharge_fk
  FOREIGN KEY (note_id)
  REFERENCES mimiciv_note.src_discharge (note_id);

-- radiology

ALTER TABLE mimiciv_note.src_radiology DROP CONSTRAINT IF EXISTS radiology_patients_fk;
ALTER TABLE mimiciv_note.src_radiology
ADD CONSTRAINT radiology_patients_fk
  FOREIGN KEY (subject_id)
  REFERENCES mimiciv_hosp.src_patients (subject_id);

ALTER TABLE mimiciv_note.src_radiology DROP CONSTRAINT IF EXISTS radiology_admissions_fk;
ALTER TABLE mimiciv_note.src_radiology
ADD CONSTRAINT radiology_admissions_fk
  FOREIGN KEY (hadm_id)
  REFERENCES mimiciv_hosp.src_admissions (hadm_id);

-- radiology_detail

ALTER TABLE mimiciv_note.src_radiology_detail DROP CONSTRAINT IF EXISTS radiology_detail_radiology_fk;
ALTER TABLE mimiciv_note.src_radiology_detail
ADD CONSTRAINT radiology_detail_radiology_fk
  FOREIGN KEY (note_id)
  REFERENCES mimiciv_note.src_radiology (note_id);