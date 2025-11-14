SELECT 
    d.name AS driver_name,
    ri.name AS rider_name,
    r.pickup_city,
    r.dropoff_city,
    r.distance_km,
    p.method AS payment_method
FROM rides_cleaned r
JOIN drivers_cleaned d 
    ON r.driver_id = d.driver_id
JOIN riders_cleaned ri 
    ON r.rider_id = ri.rider_id
JOIN payments_cleaned p 
    ON r.ride_id = p.ride_id
ORDER BY r.distance_km DESC
LIMIT 10;
