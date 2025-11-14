SELECT 
    d.driver_id,
    d.name AS driver_name,
    COUNT(r.ride_id) AS total_rides,
    d.rating AS avg_rating,
    ROUND(
        (SUM(CASE WHEN r.status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(r.ride_id),
        2
    ) AS cancellation_rate
FROM 
    rides_cleaned r
JOIN 
    drivers_cleaned d 
    ON r.driver_id = d.driver_id
GROUP BY 
    d.driver_id, d.name, d.rating
HAVING 
    COUNT(r.ride_id) >= 30
    AND AVG(d.rating) >= 4.5
    AND (SUM(CASE WHEN r.status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(r.ride_id)) < 5
ORDER BY 
    avg_rating DESC,
    total_rides DESC
LIMIT 10;
