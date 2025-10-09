CREATE OR REPLACE TABLE `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean` AS
WITH parsed AS (
  SELECT
    t.*,
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^(\d+):') AS INT64)                AS h,
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^\d+:(\d{1,2})') AS INT64)         AS m,
    SAFE_CAST(REGEXP_EXTRACT(t.ride_length, r'^\d+:\d{1,2}:(\d{1,2})') AS INT64) AS s
  FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1` AS t
)
SELECT
  CAST(trip_id AS STRING) AS ride_id,
  CAST(start_time AS TIMESTAMP) AS started_at,
  CAST(end_time  AS TIMESTAMP) AS ended_at,
  from_station_id  AS start_station_id,
  from_station_name,
  to_station_id    AS end_station_id,
  to_station_name,
  -- Convert old 'usertype' into modern schema
  CASE WHEN usertype = 'Subscriber' THEN 'member' ELSE 'casual' END AS member_casual,
  (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) AS ride_length_minutes,
  day_of_week
FROM parsed
WHERE (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) > 0
  AND (COALESCE(h,0) * 60 + COALESCE(m,0) + COALESCE(s,0) / 60.0) < 24*60;
