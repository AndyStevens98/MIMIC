# What Andy Has Updated for Postgres

## Vocab Needed from Athena

So far has been SNOMED, LOINC, RxNorm, RxNorm Extension, NDC, DRG, CPT4, ICD9Proc, ICD10PCS, HCPCS

## Staging
* etl/staging/st1_hosp.sql
    * Requires tables: patients, admissions, transfers, diagnoses_icd, services, labevents, d_labitems, procedures_icd, hcpcsevents, drgcodes, prescriptions, microbiologyevents, pharmacy
    * Updated for postgres
* etl/staging/st1_icu.sql
    * Requires tables: procedurevents, d_items, datetimeevents, chartevents
    * Updated for postgres
* etl/2_staging/st2_constraint.sql
    * Run this after running the two st1 scripts above
* etl/2_staging/st2_index.sql
    * Run this after running st2_constraint.sql
* etl/staging/voc_copy_to_target_dataset.sql
    * Requires tables: concept, concept_relationship, vocabulary, domain, concept_class, relationship, concept_synonym, concept_ancestor, drug_strength
    * Note for these: would recommend just creating all of the above with voc_ prepended and load with data from Athena download, plus custom concepts and concept_relationships from the custom mapping folder as shown below
* custom_mapping_csv/*
    * This folder has all of the custom concepts and concept relationships that are needed to be in the voc_concept and voc_concept_relationship tables. Theres a Python script in here that will turn the custom mappings into CSVs for easy import into the tables directly via PSQL

## ETL
* etl/etl/1_cdm_location.sql
    * Requires no other tables
    * Updated for postgres
* etl/etl/2_cdm_care_site.sql
    * Requires tables: src_transfers, lk_trans_careunit_clean (created in script), voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_cs_place_of_service
    * Updated for postgres
* etl/etl/3_cdm_person.sql
    * Requires tables: src_admissions, src_patients, lk_pat_race_concept (created in script), voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_per_ethnicity
    * Updated for postgres
* etl/etl/4_cdm_death.sql
    * Requires tables: src_admissions, lk_death_adm_mapped (created in script)
    * Updated for postgres

* etl/etl/5_lk_vis_part_1.sql
    * Requires tables: src_admissions, src_transfers, src_services,  lk_admissions_clean
    * Updated for postgres

* etl/etl/6_lk_meas_unit.sql
    * Requires tables: voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_meas_unit
    * Updated for postgres
* etl/etl/7_lk_meas_chartevents.sql
    * Requires function REGEXP_EXTRACT (included in file if not already exists)
    * Requires tables: src_chartevents, src_d_items, voc_concept, voc_concept_relationship, lk_chartevents_clean, lk_chartevents_concept
    * Requires vocab: gcpt_meas_chartevents_value
    * Updated for postgres
* etl/etl/8_lk_meas_labevents.sql
    * Requires tables: src_d_labitems, src_labevents, lk_admissions_clean, lk_meas_d_labitems_clean, lk_meas_labevents_clean, lk_meas_operator_concept, lk_meas_unit_concept, lk_meas_labevents_hadm_id, voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_meas_lab_loinc
    * Updated for postgres
* etl/etl/9_lk_meas_specimen.sql
    * Requires tables: src_microbiologyevents, lk_micro_cross_ref, lk_admissions_clean, lk_meas_organism_clean, lk_meas_ab_clean, lk_meas_operator_concept, lk_d_micro_clean, lk_d_micro_concept, lk_specimen_clean, lk_micro_hadm_id, voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_micro_specimen, gcpt_micro_microtest, gcpt_micro_organism, gcpt_micro_antibiotic, gcpt_micro_resistance
    * Updated for postgres
* etl/etl/10_lk_meas_waveform.sql
    * This was skipped since we are not using the waveform data
    * Requires tables: src_waveform_mx, src_waveform_header, src_patients, src_waveform_mx_3, src_waveform_header_3, lk_waveform_clean, lk_admissions_clean, lk_meas_unit_concept, lk_wf_hadm_id, voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_meas_unit, gcpt_meas_waveforms
    * Updated for postgres

* etl/etl/11_lk_vis_part_2.sql
    * Requires tables: lk_meas_labevents_mapped, lk_specimen_mapped, lk_meas_organism_mapped, lk_meas_ab_mapped, lk_visit_no_hadm_all, lk_visit_no_hadm_dist, lk_admissions_clean, lk_transfers_clean, lk_services_clean, lk_visit_detail_clean, lk_visit_clean, voc_concept, voc_concept_relationship
    * Required vocabulary: gcpt_vis_admission, gcpt_cs_place_of_service
    * Updated for postgres
* etl/etl/12_cdm_visit_occurrence.sql
    * Requires tables: lk_visit_clean, lk_visit_concept, cdm_person, cdm_care_site
    * Updated for postgres
* etl/etl/13_cdm_visit_detail.sql
    * Requires tables: lk_visit_detail_prev_next, lk_visit_concept, cdm_person, cdm_visit_occurrence, cdm_care_site
    * Updated for postgres

* etl/etl/14_lk_cond_diagnoses.sql
    * Requires tables: src_diagnoses_icd, src_admissions, lk_diagnoses_icd_clean, voc_concept, voc_concept_relationship
    * Updated for postgres
* etl/etl/15_lk_procedure.sql
    * Requires tables: src_hcpcsevents, src_admissions, src_procedures_icd, src_procedureevents, src_datetimeevents, src_patients, src_d_items, lk_hcpcsevents_clean, lk_hcpcs_concept, lk_procedures_icd_clean, lk_icd_proc_concept, lk_proc_d_items_clean, lk_itemid_concept voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_proc_itemid, gcpt_proc_datetimeevents
    * Updated for postgres
* etl/etl/16_lk_observation.sql
    * Requires tables: src_admissions, src_drgcodes, lk_observation_clean, lk_obs_admissions_concept, voc_concept, voc_concept_relationship
    * Requires vocab: gcpt_obs_insurance, gcpt_obs_marital, gcpt_obs_drgcodes
    * Updated for postgres

* etl/etl/17_dm_condition_occurrence.sql
    * Requires tables: lk_diagnoses_icd_mapped, lk_chartevents_condition_mapped, lk_chartevents_mapped, cdm_person, cdm_visit_occurrence
    * Updated for postgres
* etl/etl/18_cdm_procedure_occurrence.sql
    * Requires tables: lk_procedure_mapped, lk_observation_mapped, lk_specimen_mapped, lk_chartevents_mapped, cdm_person, cdm_visit_occurrence
    * Updated for postgres

* etl/etl/19_cdm_specimen.sql
    * Requires tables: lk_specimen_mapped, cdm_person
    * Updated for postgres
* etl/etl/20_cdm_measurement.sql
    * Requires tables: lk_chartevents_mapped, lk_meas_labevents_mapped, lk_meas_organism_mapped, lk_meas_ab_mapped, cdm_person, cdm_visit_occurrence
    * Updated for postgres

* etl/etl/21_lk_drug.sql
    * Requires tables: src_prescriptions, src_pharmacy, voc_concept, voc_concept_relationship, lk_prescriptions_clean, lk_pr_ndc_concept, lk_pr_gcpt_concept, lk_pr_route_concept
    * Requires vocab: gcpt_drug_ndc, gcpt_drug_route
    * Updated for postgres
* etl/etl/22_cdm_drug_exposure.sql
    * Requires tables: lk_drug_mapped, cdm_person, cdm_visit_occurrence
    * Updated for postgres
* etl/etl/23_cdm_device_exposure.sql
    * Requires tables: lk_drug_mapped, lk_chartevents_mapped, cdm_person, cdm_visit_occurence

* etl/etl/24_cdm_observation.sql
    * Requires tables: lk_chartevents_mapped, lk_diagnoses_icd_mapped, lk_observation_mapped, lk_procedure_mapped, lk_specimen_mapped, cdm_person, cdm_visit_occurrence
    * Updated for postgres

* etl/etl/25_cdm_observation_period.sql
    * Requires tables: cdm_visit_occurrence, cdm_condition_occurrence, cdm_procedure_occurrence, cdm_drug_exposure, cdm_device_exposure, cdm_measurement, cdm_specimen, cdm_observation, cdm_death
* etl/etl/26_cdm_finalize_person.sql
    * Requires tables: cdm_person, cdm_observation_period
    * Updated for postgres

* etl/etl/27_cdm_fact_relationship.sql
    * Requires tables: lk_specimen_mapped, lk_meas_organism_mapped, lk_meas_ab_mapped
    * Updated for postgres

* etl/etl/28_cdm_condition_era.sql
    * Requires functions DATE_ADD and DATE_SUB (included in file if not exists)
    * Requires tables: cdm_condition_occurrence
    * Updated for postgres
* etl/etl/29_cdm_drug_era.sql
    * Requires tables: lk_join_voc_drug, voc_concept_ancestor, voc_concept, cdm_drug_exposure
    * Updated for postgres
* etl/etl/30_cdm_dose_era.sql
    * Requires tables: cdm_drug_exposure, voc_drug_strength, voc_concept_ancestor, voc_concept
    * Updated for postgres

* etl/etl/31_ext_d_itemid_to_concept.sql
    * Requires tables: lk_chartevents_mapped, lk_meas_labevents_mapped, lk_meas_d_labitems_concept, lk_procedure_mapped, lk_specimen_mapped, lk_meas_organism_mapped, lk_meas_ab_mapped, lk_d_micro_concept, voc_concept
    * Updated for postgres
* etl/etl/32_cdm_cdm_source.sql
    * Requires tables: voc_vocabulary

* etl/etl/33_cdm_provider.sql
    * Requires tables: ?
    * This is kind of useless since theres no info beyond just provider id/cargiver id

* etl/clean/observation_concept_matching.sql
    * Helps fix some of the value_as_concept_id that are 0 when they should have a value but was just missing vocab
* etl/clean/drug_exposure_concept_matching.sql
    * Requires the MIMICIV_Drugs_mapped.csv, this was manually created by me (using OHDSI's Usagi) so it might not be 100% accurate but its based on what it sounds like to be true
* etl/clean/f_person_population.py
    * Will take an exported person table and create an f_person table for OMOPonFHIR