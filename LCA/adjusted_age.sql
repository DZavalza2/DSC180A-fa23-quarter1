-- This SQL script creates a view from MIMIC III data to analyze ICU stays.
-- It computes the length of stay in the ICU and the age of the patients, 
-- filtering out patients under the age of 16 and considering only the first ICU stay.


CREATE TABLE Adjusted_age AS
WITH co AS
(
  SELECT icu.subject_id, icu.hadm_id, icu.icustay_id
  , FLOOR(EXTRACT(EPOCH FROM outtime - intime)/60.0/60.0/24.0) as icu_length_of_stay
  , FLOOR(EXTRACT('epoch' from icu.intime - pat.dob) / 60.0 / 60.0 / 24.0 / 365.242) as age
  , RANK() OVER (PARTITION BY icu.subject_id ORDER BY icu.intime) AS icustay_id_order
  FROM mimiciii.icustays icu
  INNER JOIN mimiciii.patients pat
    ON icu.subject_id = pat.subject_id
)
, serv AS
(
  SELECT icu.hadm_id, icu.icustay_id, se.curr_service
  , CASE
      WHEN curr_service like '%SURG' then 1
      WHEN curr_service = 'ORTHO' then 1
      ELSE 0 END
    as surgical
  , RANK() OVER (PARTITION BY icu.hadm_id ORDER BY se.transfertime DESC) as rank
  FROM mimiciii.icustays icu
  LEFT JOIN mimiciii.services se
    ON icu.hadm_id = se.hadm_id
    AND se.transfertime < icu.intime + interval '12' hour
)
SELECT
  subquery.subject_id, subquery.hadm_id, subquery.icustay_id, subquery.icu_length_of_stay
  , subquery.age
  , subquery.icustay_id_order
  , subquery.exclusion_age
FROM (
  SELECT
    co.subject_id, co.hadm_id, co.icustay_id, co.icu_length_of_stay
    , co.age
    , co.icustay_id_order
    , CASE
        WHEN co.age < 16 then 1
        ELSE 0 END
        AS exclusion_age
  FROM co
  LEFT JOIN serv
    ON  co.icustay_id = serv.icustay_id
    AND serv.rank = 1
) AS subquery
WHERE subquery.icustay_id_order = 1 AND subquery.exclusion_age = 0;
