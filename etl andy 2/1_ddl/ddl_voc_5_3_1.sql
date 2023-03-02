-- ----------------------------------------------------------------------------
-- MIMIC IV to OMOP CDM
-- Andy Stevens, GTRI, Feb 2023
-- ----------------------------------------------------------------------------
/*OMOP CDM v5.3.1 14June2018*/

CREATE TABLE voc_concept (
  concept_id INTEGER not null,
  concept_name VARCHAR not null,
  domain_id VARCHAR not null,
  vocabulary_id VARCHAR not null,
  concept_class_id VARCHAR not null,
  standard_concept VARCHAR,
  concept_code VARCHAR not null,
  valid_start_DATE DATE not null,
  valid_end_DATE DATE not null,
  invalid_reason VARCHAR
);

CREATE TABLE voc_vocabulary (
  vocabulary_id VARCHAR not null,
  vocabulary_name VARCHAR not null,
  vocabulary_reference VARCHAR not null,
  vocabulary_version VARCHAR,
  vocabulary_concept_id INTEGER not null
);

CREATE TABLE voc_domain (
  domain_id VARCHAR not null,
  domain_name VARCHAR not null,
  domain_concept_id INTEGER not null
);

CREATE TABLE voc_concept_class (
  concept_class_id VARCHAR not null,
  concept_class_name VARCHAR not null,
  concept_class_concept_id INTEGER not null
);
CREATE TABLE voc_concept_relationship (
  concept_id_1 INTEGER not null,
  concept_id_2 INTEGER not null,
  relationship_id VARCHAR not null,
  valid_start_DATE DATE not null,
  valid_end_DATE DATE not null,
  invalid_reason VARCHAR
);
CREATE TABLE voc_relationship (
  relationship_id VARCHAR not null,
  relationship_name VARCHAR not null,
  is_hierarchical VARCHAR not null,
  defines_ancestry VARCHAR not null,
  reverse_relationship_id VARCHAR not null,
  relationship_concept_id INTEGER not null
);
CREATE TABLE voc_concept_synonym (
  concept_id INTEGER not null,
  concept_synonym_name VARCHAR not null,
  language_concept_id INTEGER not null
);
CREATE TABLE voc_concept_ancestor (
  ancestor_concept_id INTEGER not null,
  descendant_concept_id INTEGER not null,
  min_levels_of_separation INTEGER not null,
  max_levels_of_separation INTEGER not null
);
CREATE TABLE voc_source_to_concept_map (
  source_code VARCHAR not null,
  source_concept_id INTEGER not null,
  source_vocabulary_id VARCHAR not null,
  source_code_description VARCHAR,
  target_concept_id INTEGER not null,
  target_vocabulary_id VARCHAR not null,
  valid_start_DATE DATE not null,
  valid_end_DATE DATE not null,
  invalid_reason VARCHAR
);
CREATE TABLE voc_drug_strength (
  drug_concept_id INTEGER not null,
  ingredient_concept_id INTEGER not null,
  amount_value FLOAT,
  amount_unit_concept_id INTEGER,
  numerator_value FLOAT,
  numerator_unit_concept_id INTEGER,
  denominator_value FLOAT,
  denominator_unit_concept_id INTEGER,
  box_size INTEGER,
  valid_start_DATE DATE not null,
  valid_end_DATE DATE not null,
  invalid_reason VARCHAR
);