SELECT 
    COUNT(DISTINCT r.rider_id) AS active_2021_riders_in_2024
FROM riders_cleaned r
JOIN rides_cleaned rd 
    ON r.rider_id = rd.rider_id
WHERE EXTRACT(YEAR FROM r.signup_date) = 2021
  AND EXTRACT(YEAR FROM rd.request_date) = 2024;
