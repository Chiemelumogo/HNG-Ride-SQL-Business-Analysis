WITH rider_ride_counts AS (
    SELECT
        rider_id,
        COUNT(DISTINCT ride_id) AS total_rides
    FROM rides_cleaned
    GROUP BY rider_id
),
riders_no_cash AS (
    SELECT
        r.rider_id
    FROM payments_cleaned p
    JOIN rides_cleaned r ON p.ride_id = r.ride_id
    GROUP BY r.rider_id
    HAVING SUM(CASE WHEN LOWER(p.method) = 'cash' THEN 1 ELSE 0 END) = 0
)
SELECT
    rc.rider_id,
    rd.name AS rider_name,
    rc.total_rides
FROM rider_ride_counts rc
JOIN riders_no_cash nc ON rc.rider_id = nc.rider_id
JOIN riders_cleaned rd ON rc.rider_id = rd.rider_id
WHERE rc.total_rides > 10
ORDER BY rc.total_rides DESC;
