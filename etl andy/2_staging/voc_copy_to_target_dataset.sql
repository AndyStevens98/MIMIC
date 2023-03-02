-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Copy vocabulary tables from the master vocab dataset
-- (to apply custom mapping here?)
-- -------------------------------------------------------------------

-- check
-- SELECT 'VOC', COUNT(*) FROM public.concept
-- UNION ALL
-- SELECT 'TARGET', COUNT(*) FROM public.voc_concept
-- ;

-- affected by custom mapping

CREATE OR REPLACE TABLE public.voc_concept AS
SELECT * FROM public.concept
;

CREATE OR REPLACE TABLE public.voc_concept_relationship AS
SELECT * FROM public.concept_relationship
;

CREATE OR REPLACE TABLE public.voc_vocabulary AS
SELECT * FROM public.vocabulary
;

-- not affected by custom mapping

CREATE OR REPLACE TABLE public.voc_domain AS
SELECT * FROM public.domain
;
CREATE OR REPLACE TABLE public.voc_concept_class AS
SELECT * FROM public.concept_class
;
CREATE OR REPLACE TABLE public.voc_relationship AS
SELECT * FROM public.relationship
;
CREATE OR REPLACE TABLE public.voc_concept_synonym AS
SELECT * FROM public.concept_synonym
;
CREATE OR REPLACE TABLE public.voc_concept_ancestor AS
SELECT * FROM public.concept_ancestor
;
CREATE OR REPLACE TABLE public.voc_drug_strength AS
SELECT * FROM public.drug_strength
;

