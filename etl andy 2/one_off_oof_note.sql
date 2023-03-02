CREATE TABLE tmp_note AS
    SELECT
        dis.note_id AS note_id,
        dis.subject_id AS subject_id,
        dis.hadm_id AS hadm_id,
        dis.note_type AS note_type,
        dis.note_seq AS note_seq,
        dis.charttime AS charttime,
        dis.storetime AS storetime,
        dis.text AS text,
        disdet.field_name AS field_name,
        disdet.field_ordinal AS field_ordinal,
        disdet.field_value AS field_value
    FROM mimiciv_note.discharge dis
    LEFT JOIN mimiciv_note.discharge_detail disdet
        ON dis.note_id = disdet.note_id
    UNION ALL
    SELECT
        rad.note_id AS note_id,
        rad.subject_id AS subject_id,
        rad.hadm_id AS hadm_id,
        rad.note_type AS note_type,
        rad.note_seq AS note_seq,
        rad.charttime AS charttime,
        rad.storetime AS storetime,
        rad.text AS text,
        raddet.field_name AS field_name,
        raddet.field_ordinal AS field_ordinal,
        raddet.field_value AS field_value
    FROM mimiciv_note.radiology rad
    LEFT JOIN mimiciv_note.radiology_detail raddet
        ON rad.note_id = raddet.note_id



INSERT INTO note 
SELECT
