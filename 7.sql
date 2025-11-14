WITH city_revenue AS (
    SELECT
        r.pickup_city AS city,
        r.driver_id,
        d.name AS driver_name,
        SUM(p.amount) AS total_revenue
    FROM rides_cleaned r
    JOIN payments_cleaned p ON r.ride_id = p.ride_id
    JOIN drivers_cleaned d ON r.driver_id = d.driver_id
    WHERE r.pickup_date BETWEEN '2021-06-01' AND '2024-12-31'
    GROUP BY r.pickup_city, r.driver_id, d.name
),
ranked_drivers AS (
    SELECT
        city,
        driver_id,
        driver_name,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_revenue DESC) AS city_rank
    FROM city_revenue
)
SELECT
    city,
    driver_id,
    driver_name,
    total_revenue,
    city_rank
FROM ranked_drivers
WHERE city_rank <= 3
ORDER BY city, city_rank;
