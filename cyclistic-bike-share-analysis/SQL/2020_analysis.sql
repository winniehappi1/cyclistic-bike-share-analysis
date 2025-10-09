CREATE OR REPLACE TABLE `cyclistic0610.cyclistic.Divvy_Trips_2020_Q1_clean` AS
WITH parsed AS (
  SELECT
    t.*,
    -- Extract hours, minutes, optional seconds from 'HH:MM[:SS]'
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^(\d+):') AS INT64)                AS h,
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^\d+:(\d{1,2})') AS INT64)         AS m,
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^\d+:\d{1,2}:(\d{1,2})') AS INT64) AS s
  FROM `cyclistic0610.cyclistic.Divvy_Trips_2020_Q1` AS t
)
SELECT
  parsed.* EXCEPT(h, m, s),
  (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) AS ride_length_minutes
FROM parsed
WHERE (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) > 0
  AND (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) < 24*60;
