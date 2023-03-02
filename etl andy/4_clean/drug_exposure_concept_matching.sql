-- -------------------------------------------------------------------
-- Update drug_exposure table with tmp_drug_mapping table
-- -------------------------------------------------------------------
-- You will need to upload the CSV to a table called tmp_drug_mapping to do this matching
-- -------------------------------------------------------------------
-- drug_exposure_updated
-- -------------------------------------------------------------------
CREATE TABLE drug_exposure_updated AS
    SELECT
        de.drug_exposure_id,
        person_id,
        CASE
            WHEN de.drug_concept_id != 0 THEN de.drug_concept_id
            WHEN de.drug_source_value = tdm.drug_source_value THEN tdm.target_concept_id
            ELSE 0
        END as drug_concept_id,
        drug_exposure_start_date,
        drug_exposure_start_datetime,
        drug_exposure_end_date,
        drug_exposure_end_datetime,
        verbatim_end_date,
        drug_type_concept_id,
        stop_reason,
        refills,
        quantity,
        days_supply,
        sig,
        route_concept_id,
        lot_number,
        provider_id,
        visit_occurrence_id,
        visit_detail_id,
        de.drug_source_value,
        CASE
            WHEN de.drug_source_concept_id != 0 THEN de.drug_source_concept_id
            WHEN de.drug_source_value = tdm.drug_source_value THEN tdm.target_concept_id
            ELSE 0
        END as drug_source_concept_id,
        route_source_value,
        dose_unit_source_value
    FROM drug_exposure de
    LEFT JOIN tmp_drug_mapping tdm on de.drug_source_value = tdm.drug_source_value;

DROP TABLE IF EXISTS tmp_drug_mapping;
DROP TABLE IF EXISTS drug_exposure;
ALTER TABLE drug_exposure_updated RENAME TO drug_exposure;