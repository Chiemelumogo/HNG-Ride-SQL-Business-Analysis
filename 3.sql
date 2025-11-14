WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM paid_date) AS year,
        EXTRACT(QUARTER FROM paid_date) AS quarter,
        SUM(amount) AS total_revenue
    FROM payments_cleaned
    WHERE paid_date BETWEEN '2021-01-01' AND '2024-12-31'
    GROUP BY EXTRACT(YEAR FROM paid_date), EXTRACT(QUARTER FROM paid_date)
),
yoy_growth AS (
    SELECT
        curr.year,
        curr.quarter,
        curr.total_revenue,
        prev.total_revenue AS prev_year_revenue,
        ROUND(
            ((curr.total_revenue - prev.total_revenue) / NULLIF(prev.total_revenue, 0)) * 100, 
            2
        ) AS yoy_growth_percent
    FROM quarterly_revenue curr
    LEFT JOIN quarterly_revenue prev
        ON curr.quarter = prev.quarter
       AND curr.year = prev.year + 1
)
SELECT 
    year, 
    quarter, 
    total_revenue,
    prev_year_revenue,
    yoy_growth_percent
FROM yoy_growth
ORDER BY year, quarter;
