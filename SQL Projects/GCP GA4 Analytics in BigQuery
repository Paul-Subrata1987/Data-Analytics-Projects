---FINAL Queries - Project 3 Google Analytics


-- Total Users count for last 180 days

SELECT
    parse_date('%Y%m%d', event_date) as Event_Date,
    count(distinct user_pseudo_id) as Users
FROM `datacareerapp.analytics_475926274.events_*`
WHERE _TABLE_SUFFIX between 
  FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 180 DAY)) and 
  FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY Event_Date ORDER BY Event_Date DESC;




-- Total new users count for last 30 days


SELECT
    parse_date('%Y%m%d', event_date) as Event_Date,
    count(distinct user_pseudo_id) as Users
FROM `datacareerapp.analytics_475926274.events_*`
WHERE event_name = 'first_visit' AND _TABLE_SUFFIX between 
  FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 28 DAY)) and 
  FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY Event_Date ORDER BY Event_Date DESC;



-- Total Session 

SELECT
    parse_date('%Y%m%d', event_date) as Event_Date,
    COUNT(DISTINCT ( 
      SELECT value.int_value 
      FROM UNNEST(event_params) 
      WHERE key = 'ga_session_id' 
    )) AS num_sessions 
FROM `datacareerapp.analytics_475926274.events_*`
WHERE event_name = 'session_start' AND _TABLE_SUFFIX between 
  FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 28 DAY)) and 
  FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY Event_Date 
ORDER BY Event_Date DESC;


-- Engagement Rate 


WITH sessions AS ( 
  SELECT 
    DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date, 
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key='ga_session_id') AS session_id, 
    MAX((SELECT value.int_value FROM UNNEST(event_params) WHERE key='session_engaged')) AS engaged_flag 
  FROM `datacareerapp.analytics_475926274.events_*`
  WHERE _TABLE_SUFFIX BETWEEN 
      FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) AND 
      FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY event_date, session_id 
) 

SELECT 
  event_date, 
  COUNT(*) AS total_sessions, 
  SUM(engaged_flag) AS engaged_sessions, 
  IFNULL(SAFE_DIVIDE(SUM(engaged_flag), COUNT(*)), 0) AS engagement_rate 
FROM sessions 
GROUP BY event_date 
ORDER BY event_date; 




-- Average Session Duration

WITH sessions AS ( 
  SELECT 
    user_pseudo_id, 
    (SELECT value.int_value 
     FROM UNNEST(event_params) 
     WHERE key = 'ga_session_id') AS session_id, 
    event_timestamp 
  FROM `datacareerapp.analytics_475926274.events_*`
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)) 
                          AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
    AND EXISTS ( 
      SELECT 1 FROM UNNEST(event_params) WHERE key = 'ga_session_id' 
    ) 
),

avg_duration as (SELECT 
  user_pseudo_id, 
  session_id, 
  DATE(TIMESTAMP_MICROS(MIN(event_timestamp))) AS session_date, 
  (MAX(event_timestamp) - MIN(event_timestamp)) / 1e6 AS session_duration_seconds 
FROM sessions 
GROUP BY user_pseudo_id, session_id 
ORDER BY session_date
)


SELECT
  session_date,
  session_duration_seconds
from avg_duration;

--Session bin pie charts

WITH sessions AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'ga_session_id') AS session_id,
    event_timestamp
  FROM `datacareerapp.analytics_475926274.events_*`
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY))
                          AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
),
 
session_durations AS (
 SELECT
  user_pseudo_id,
  session_id,
  DATE(TIMESTAMP_MICROS(MIN(event_timestamp))) AS session_date,
  (MAX(event_timestamp) - MIN(event_timestamp)) / 1e6 AS session_duration_seconds
 FROM sessions
 GROUP BY user_pseudo_id, session_id
)
 
SELECT
  CASE
    WHEN session_duration_seconds <= 10 THEN '0-10s'
    WHEN session_duration_seconds <= 30 THEN '10-30'
    WHEN session_duration_seconds <= 60 THEN '31-60s'
    WHEN session_duration_seconds <= 90 THEN '61-90s'
    ELSE '91s+'
  END AS duration_bin,
  COUNT(DISTINCT user_pseudo_id) AS num_users
FROM session_durations
GROUP BY duration_bin
ORDER BY num_users;






-- User Geography 

SELECT
    geo.continent as continent,
    geo.country as country,
    geo.region as region,
    geo.city as city,
    count(distinct user_pseudo_id) as users,
    count(*) as events
FROM `datacareerapp.analytics_475926274.events_*`
WHERE _TABLE_SUFFIX between 
                    FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 30 DAY)) and 
                    FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY continent, country, region, city
ORDER BY users DESC;






-- Top events triggered

SELECT
    event_name,
    COUNT(*) as event_count
FROM `datacareerapp.analytics_475926274.events_*`
WHERE _TABLE_SUFFIX between 
    FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 30 DAY)) and 
    FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 1 DAY))
GROUP BY event_name
ORDER BY event_count DESC;




-- Top Pages Viewed


SELECT 
  (SELECT value.string_value 
   FROM UNNEST(event_params) 
   WHERE key = 'page_title') AS page_title, 
  COUNT(*) AS page_count 
FROM `datacareerapp.analytics_475926274.events_*`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY page_title 
ORDER BY page_count DESC;




---device_category_breakdown:
--- samarth will come back on this

SELECT 
  COUNT(DISTINCT(user_pseudo_id)), 
  device.category as device_category 
FROM `datacareerapp.analytics_475926274.events_*` 
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY device_category;




SELECT
    device.category as device_type,
    count(distinct user_pseudo_id) as users,
    count(*) as events
FROM `datacareerapp.analytics_475926274.events_*`
WHERE _TABLE_SUFFIX between 
                    FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 180 DAY)) and 
                    FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY device_type
ORDER BY users DESC;



---traffic_source: 

SELECT  
  session_traffic_source_last_click.cross_channel_campaign.default_channel_group AS channel_group, 
  COUNT(DISTINCT user_pseudo_id) as users_count 
FROM `datacareerapp.analytics_475926274.events_*` 
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY channel_group 
ORDER BY channel_group;



--User hourly trend analysis

SELECT   
  FORMAT_DATETIME('%H',datetime(timestamp_micros(event_timestamp),'Australia/Sydney')) AS hour_format,  
  FORMAT_DATETIME('%I %p',datetime(timestamp_micros(event_timestamp), 'Australia/Sydney')) AS syd_time,  
  COUNT(distinct user_pseudo_id) AS Users,  
  COUNT(*) AS event  
FROM `datacareerapp.analytics_475926274.events_*`  
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 180 DAY)) AND   
                            FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY hour_format, syd_time;


-- Weekly trend analysis

SELECT 
  FORMAT_DATETIME('%A',PARSE_DATE('%Y%m%d', event_date)) AS weekday,  
  EXTRACT(DAYOFWEEK from PARSE_DATE('%Y%m%d', event_date)) AS weekday_num,  
  COUNT(distinct user_pseudo_id) AS users, 
  COUNT(*) AS event  
FROM `datacareerapp.analytics_475926274.events_*` 
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(current_date(), INTERVAL 180 DAY)) AND   
                            FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
GROUP BY weekday, weekday_num  
ORDER BY weekday_num;



---RETENTION COHORT (Week 0 → Week 4)
---Need to double check, having issues - Samarth will come back on this

WITH new_users_week_5 AS ( 
  SELECT DISTINCT user_pseudo_id 
  FROM `datacareerapp.analytics_475926274.events_*`  
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 35 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
    AND DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) 
        BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 35 DAY) 
            AND DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY) 
) 
 
SELECT  
  COUNT(DISTINCT user_pseudo_id) AS returned_users 
FROM   
  `datacareerapp.analytics_475926274.events_*`  
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
                        AND user_pseudo_id IN (SELECT user_pseudo_id FROM new_users_week_5);









WITH first_visit AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
  FROM `datacareerapp.analytics_475926274.events_*`
  WHERE event_name = 'first_visit'
  GROUP BY user_pseudo_id
),

user_activity AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS activity_date
  FROM `datacareerapp.analytics_475926274.events_*`
  WHERE _TABLE_SUFFIX BETWEEN
  FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
),

cohorts AS (
  SELECT
    f.user_pseudo_id,
    f.first_date,
    DATE_DIFF(a.activity_date, f.first_date, WEEK) AS week_number    
  FROM first_visit f
  JOIN user_activity a
    ON f.user_pseudo_id = a.user_pseudo_id
)

SELECT
  first_date AS cohort_date,
  week_number,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM cohorts
WHERE week_number BETWEEN 0 AND 4
GROUP BY cohort_date, week_number
ORDER BY cohort_date, week_number;





--- USER Flow and Path Analysis

WITH page_views AS ( 

  SELECT  
    user_pseudo_id, 
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key='ga_session_id') AS session_id, 
    TIMESTAMP_MICROS(event_timestamp) AS event_time, 
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key='page_title') AS page_title 
  FROM `datacareerapp.analytics_475926274.events_*` 

  WHERE _TABLE_SUFFIX BETWEEN 
    FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) AND 
    FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 

), 

ordered_pages AS ( 

  SELECT 
    user_pseudo_id, 
    session_id, 
    page_title, 
    LEAD(page_title) OVER ( 
      PARTITION BY user_pseudo_id, session_id 
      ORDER BY event_time 
    ) AS next_page 
  FROM page_views 
) 
 

SELECT 
  page_title AS source, 
  next_page AS target, 
  COUNT(*) AS value 
FROM ordered_pages 
WHERE next_page IS NOT NULL 
  AND page_title != next_page 
GROUP BY source, target 
HAVING COUNT(*) >= 10 
ORDER BY value DESC;



--- Entry vs Exit Pages


WITH pageviews AS ( 
  SELECT 
    user_pseudo_id, 
    (SELECT value.int_value 
     FROM UNNEST(event_params) 
     WHERE key = 'ga_session_id') AS session_id, 
    event_timestamp, 
    (SELECT value.string_value 
     FROM UNNEST(event_params) 
     WHERE key = 'page_title') AS page_title 
  FROM `datacareerapp.analytics_475926274.events_*` 
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY)) 
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
                        AND event_name = 'page_view' 
), 
 
ordered_pages AS ( 
  SELECT 
    user_pseudo_id, 
    session_id, 
    page_title, 
    event_timestamp, 
    ROW_NUMBER() OVER ( 
      PARTITION BY user_pseudo_id, session_id 
      ORDER BY event_timestamp 
    ) AS page_order, 
    ROW_NUMBER() OVER ( 
      PARTITION BY user_pseudo_id, session_id 
      ORDER BY event_timestamp DESC 
    ) AS reverse_page_order 
  FROM pageviews 
), 
 
landing_pages AS ( 
  SELECT 
    page_title, 
    COUNT(DISTINCT user_pseudo_id) AS landing_users 
  FROM ordered_pages 
  WHERE page_order = 1 
  GROUP BY page_title 
), 
 
exit_pages AS ( 
  SELECT 
    page_title, 
    COUNT(DISTINCT user_pseudo_id) AS exit_users 
  FROM ordered_pages 
  WHERE reverse_page_order = 1 
  GROUP BY page_title 
) 
 
SELECT 
  COALESCE(l.page_title, e.page_title) AS page_title, 
  IFNULL(l.landing_users, 0) AS landing_users, 
  IFNULL(e.exit_users, 0) AS exit_users, 
  IFNULL(l.landing_users, 0) - IFNULL(e.exit_users, 0) AS net_user_flow 
FROM landing_pages l 
FULL OUTER JOIN exit_pages e 
  ON l.page_title = e.page_title 
ORDER BY net_user_flow DESC 

