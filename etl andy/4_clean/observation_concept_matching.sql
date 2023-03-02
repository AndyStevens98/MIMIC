-- -------------------------------------------------------------------
-- Update observation table after adding more concepts
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- tmp_obs_no_concept_id
-- -------------------------------------------------------------------
CREATE TABLE tmp_obs_no_concept_id AS
    SELECT *
    FROM observation
    WHERE value_as_concept_id = 0;

-- -------------------------------------------------------------------
-- tmp_obs_mapping_table
-- -------------------------------------------------------------------
CREATE TABLE tmp_obs_mapping_table AS
SELECT DISTINCT o.value_as_string, c.concept_id, cr.concept_id_2
FROM tmp_obs_no_concept_id o
    LEFT JOIN concept c on c.concept_name = o.value_as_string
    LEFT JOIN concept_relationship cr on cr.concept_id_1 = c.concept_id where relationship_id = 'Maps to';

-- -------------------------------------------------------------------
-- observation_updated
-- -------------------------------------------------------------------
CREATE TABLE observation_updated AS
    SELECT
        observation_id,
        person_id,
        observation_concept_id,
        observation_date,
        observation_datetime,
        observation_type_concept_id,
        value_as_number,
        o.value_as_string,
        CASE
            WHEN o.value_as_concept_id != 0 THEN o.value_as_concept_id
            WHEN o.value_as_string = tomt.value_as_string then tomt.concept_id_2
            WHEN o.value_as_string IS NULL THEN NULL
            ELSE 0
        END as value_as_concept_id,
        qualifier_concept_id,
        unit_concept_id,
        provider_id,
        visit_occurrence_id,
        visit_detail_id,
        observation_source_value,
        observation_source_concept_id,
        unit_source_value,
        qualifier_source_value,
        value_source_value,
        observation_event_id,
        obs_event_field_concept_id
    FROM observation o
    LEFT JOIN tmp_obs_mapping_table tomt on o.value_as_string = tomt.value_as_string;

-- -------------------------------------------------------------------
-- Cleaning
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_obs_no_concept_id;
DROP TABLE IF EXISTS tmp_obs_mapping_table;
DROP TABLE IF EXISTS observation;
ALTER TABLE observation_updated RENAME TO observation;