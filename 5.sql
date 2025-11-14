WITH city_cancellation AS (
    SELECT
        pickup_city AS city,
        COUNT(*) AS total_rides,
        COUNT(*) FILTER (WHERE LOWER(status) = 'cancelled') AS cancelled_rides
    FROM rides_cleaned
    GROUP BY pickup_city
)
SELECT
    city,
    total_rides,
    cancelled_rides,
    ROUND((cancelled_rides::NUMERIC / NULLIF(total_rides, 0)) * 100, 2) AS cancellation_rate
FROM city_cancellation
ORDER BY cancellation_rate DESC;
