WITH driver_activity AS (
    SELECT
        r.driver_id,
        COUNT(r.ride_id) AS total_rides,
        MIN(d.signup_date) AS signup_date,
        MAX(r.pickup_date) AS last_ride_date
    FROM rides_cleaned r
    JOIN drivers_cleaned d ON r.driver_id = d.driver_id
    WHERE r.status = 'completed'
    GROUP BY r.driver_id
),
driver_months AS (
    SELECT
        driver_id,
        total_rides,
        signup_date,
        last_ride_date,
        GREATEST(
            (DATE_PART('year', AGE(last_ride_date, signup_date)) * 12
             + DATE_PART('month', AGE(last_ride_date, signup_date))),
            1
        ) AS active_months
    FROM driver_activity
)
SELECT
    d.driver_id,
    dc.name AS driver_name,
    ROUND((total_rides / NULLIF(active_months, 0))::NUMERIC, 2) AS avg_monthly_rides,
    total_rides,
    active_months
FROM driver_months d
JOIN drivers_cleaned dc ON d.driver_id = dc.driver_id
ORDER BY avg_monthly_rides DESC
LIMIT 5;
