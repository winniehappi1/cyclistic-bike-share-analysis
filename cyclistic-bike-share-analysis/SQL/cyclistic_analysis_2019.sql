-- 1) Avg ride length (minutes) by rider type
SELECT member_casual, AVG(ride_length_minutes) AS avg_minutes
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY member_casual;

-- 2) Total rides by rider type
SELECT member_casual, COUNT(*) AS total_rides
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY member_casual;

-- 3) Usage by day of week (count + avg)
WITH named AS (
  SELECT
    member_casual,
    day_of_week,
    CASE day_of_week
      WHEN 1 THEN 'Sun' WHEN 2 THEN 'Mon' WHEN 3 THEN 'Tue'
      WHEN 4 THEN 'Wed' WHEN 5 THEN 'Thu' WHEN 6 THEN 'Fri' WHEN 7 THEN 'Sat'
    END AS dow_name,
    ride_length_minutes
  FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
)
SELECT member_casual, day_of_week, dow_name,
       COUNT(*) AS rides,
       AVG(ride_length_minutes) AS avg_minutes
FROM named
GROUP BY member_casual, day_of_week, dow_name
ORDER BY day_of_week, member_casual;

-- 4) Hour-of-day pattern (count + avg)
SELECT EXTRACT(HOUR FROM started_at) AS hour,
       member_casual,
       COUNT(*) AS rides,
       AVG(ride_length_minutes) AS avg_minutes
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY hour, member_casual
ORDER BY hour, member_casual;

-- 5) Monthly trend within Q1 (count + avg)
SELECT EXTRACT(MONTH FROM started_at) AS month,
       member_casual,
       COUNT(*) AS rides,
       AVG(ride_length_minutes) AS avg_minutes
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY month, member_casual
ORDER BY month, member_casual;

-- 6) Top 20 start stations by rider type
SELECT start_station_id, from_station_name AS start_station_name,
       member_casual, COUNT(*) AS rides
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY start_station_id, start_station_name, member_casual
ORDER BY rides DESC
LIMIT 20;

-- 7) Duration distribution (median & p90) by rider type
SELECT member_casual,
       APPROX_QUANTILES(ride_length_minutes, 100)[SAFE_ORDINAL(50)] AS median_minutes,
       APPROX_QUANTILES(ride_length_minutes, 100)[SAFE_ORDINAL(90)] AS p90_minutes
FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
GROUP BY member_casual;

-- 8) Weekday vs weekend (optional)
WITH flagged AS (
  SELECT *,
         CASE WHEN day_of_week IN (1,7) THEN 'weekend' ELSE 'weekday' END AS wk
  FROM `cyclistic0610.cyclistic.Divvy_Trips_2019_Q1_clean`
)
SELECT member_casual, wk,
       COUNT(*) AS rides,
       AVG(ride_length_minutes) AS avg_minutes
FROM flagged
GROUP BY member_casual, wk
ORDER BY wk, member_casual;