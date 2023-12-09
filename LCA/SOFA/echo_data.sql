-- This code extracts structured data from echocardiographies
-- You can join it to the text notes using ROW_ID
-- Just note that ROW_ID will differ across versions of MIMIC-III.
CREATE OR REPLACE VIEW echo_data AS
select ROW_ID
  , subject_id, hadm_id
  , chartdate

  -- charttime is always null for echoes..
  -- however, the time is available in the echo text, e.g.:
  -- , substring(ne.text, 'Date/Time: [\[\]0-9*-]+ at ([0-9:]+)') as TIMESTAMP
  -- we can therefore impute it and re-create charttime
  , TO_TIMESTAMP(
    TO_CHAR(chartdate, 'YYYY-MM-DD') 
    || ' ' 
    || SUBSTRING(ne.text FROM 'Date/Time: .+? at ([0-9]+:[0-9]{2})') 
    || ':00', 
    'YYYY-MM-DD HH24:MI:SS'
) AS charttime


  -- explanation of below substring:
  --  'Indication: ' - matched verbatim
  --  (.*?) - match any character
  --  \n - the end of the line
  -- substring only returns the item in ()s
  -- note: the '?' makes it non-greedy. if you exclude it, it matches until it reaches the *last* \n

 , SUBSTRING(ne.text FROM 'Indication: (.*?)\n') AS Indication


  -- sometimes numeric values contain de-id text, e.g. [** Numeric Identifier **]
  -- this removes that text
  , CAST(SUBSTRING(ne.text FROM 'Height: \\x28in\\x29 ([0-9]+)') AS numeric) AS Height
  , CAST(SUBSTRING(ne.text FROM 'Weight \\x28lb\\x29: ([0-9]+)\n') AS numeric) AS Weight
  , CAST(SUBSTRING(ne.text FROM 'BSA \\x28m2\\x29: ([0-9]+) m2\n') AS numeric) AS BSA -- ends in 'm2'
  , SUBSTRING(ne.text FROM 'BP \\x28mm Hg\\x29: (.+)\n') AS BP -- Sys/Dias
  , CAST(SUBSTRING(ne.text FROM 'BP \\x28mm Hg\\x29: ([0-9]+)/[0-9]+?\n') AS numeric) AS BPSys -- first part of fraction
  , CAST(SUBSTRING(ne.text FROM 'BP \\x28mm Hg\\x29: [0-9]+/([0-9]+?)\n') AS numeric) AS BPDias -- second part of fraction
  , CAST(SUBSTRING(ne.text FROM 'HR \\x28bpm\\x29: ([0-9]+?)\n') AS numeric) AS HR

  , SUBSTRING(ne.text FROM 'Status: (.*?)\n') AS Status
  , SUBSTRING(ne.text FROM 'Test: (.*?)\n') AS Test
  , SUBSTRING(ne.text FROM 'Doppler: (.*?)\n') AS Doppler
  , SUBSTRING(ne.text FROM 'Contrast: (.*?)\n') AS Contrast
  , SUBSTRING(ne.text FROM 'Technical Quality: (.*?)\n') AS TechnicalQuality

FROM noteevents ne
where category = 'Echo';