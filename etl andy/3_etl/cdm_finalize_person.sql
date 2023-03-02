-- -------------------------------------------------------------------
-- @2020, Odysseus Data Services, Inc. All rights reserved
-- MIMIC IV CDM Conversion
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- Remove patients from cdm_person which have no records in cdm_observation_period
-- (DQD requirement)
--
-- Dependencies: run after
--      cdm_person
--      cdm_observation_period
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Known issues / Open points:
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- cdm_person
-- -------------------------------------------------------------------

CREATE TABLE public.tmp_person AS
SELECT per.*
FROM
    public.cdm_person per
INNER JOIN
    public.cdm_observation_period op
        ON  per.person_id = op.person_id
;

TRUNCATE TABLE public.cdm_person;

INSERT INTO public.cdm_person
SELECT per.*
FROM
    public.tmp_person per
;

DROP TABLE IF EXISTS public.tmp_person;
