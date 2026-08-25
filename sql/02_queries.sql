-- 1. Total Sales KPI
SELECT SUM(ev_sales_quantity) AS total_sales FROM fact_ev_sales;

-- 2. Total 2-Wheelers Sold
SELECT SUM(f.ev_sales_quantity) AS total_2w
FROM fact_ev_sales f
JOIN dim_vehicle v ON f.vehicle_id = v.vehicle_id
WHERE v.vehicle_category = '2-Wheelers';

-- 3. Overall 5-Year CAGR %
WITH sales_boundary AS (
  SELECT 
    SUM(CASE WHEN d.year = 2019 THEN f.ev_sales_quantity ELSE 0 END) AS s19,
    SUM(CASE WHEN d.year = 2023 THEN f.ev_sales_quantity ELSE 0 END) AS s23
  FROM fact_ev_sales f
  JOIN dim_date d ON f.date_id = d.date_id
)
SELECT 
  ROUND((POWER(s23::numeric / NULLIF(s19, 0), 1.0/4) - 1) * 100, 1) AS "5_Yr_CAGR_Pct"
FROM sales_boundary;

-- 4. Top State with Volume
SELECT 
  CONCAT(s.state, ' (', ROUND(SUM(f.ev_sales_quantity)/1000.0, 0), 'K)') AS top_state
FROM fact_ev_sales f
JOIN dim_state s ON f.state_id = s.state_id
GROUP BY s.state
ORDER BY SUM(f.ev_sales_quantity) DESC
LIMIT 1;

-- 5. Peak Sales Months (Seasonality)
SELECT d.month_name, SUM(f.ev_sales_quantity) AS total_sales
FROM fact_ev_sales f JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.month_name
ORDER BY total_sales DESC LIMIT 6;

-- 6. Sales by Category Share
SELECT v.vehicle_category, SUM(f.ev_sales_quantity) AS total_sales
FROM fact_ev_sales f JOIN dim_vehicle v ON f.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_category;

-- 7. YoY Growth Trend
SELECT
  d.year::text AS year,
  SUM(f.ev_sales_quantity) AS total_sales,
  ROUND(
    100.0 * (SUM(f.ev_sales_quantity) - LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year))
    / NULLIF(LAG(SUM(f.ev_sales_quantity)) OVER (ORDER BY d.year), 0), 1
  ) AS yoy_growth_pct
FROM fact_ev_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year BETWEEN 2018 AND 2023
GROUP BY d.year
ORDER BY d.year;

-- 8. 2W vs 3W Adoption Race
SELECT d.year, v.vehicle_category, SUM(f.ev_sales_quantity) AS total_sales
FROM fact_ev_sales f
JOIN dim_vehicle v ON f.vehicle_id = v.vehicle_id
JOIN dim_date d ON f.date_id = d.date_id
WHERE v.vehicle_category IN ('2-Wheelers','3-Wheelers') AND d.year BETWEEN 2019 AND 2023
GROUP BY d.year, v.vehicle_category
ORDER BY d.year;

-- 9. Fastest Growing States by CAGR
WITH y19 AS (
  SELECT s.state, SUM(f.ev_sales_quantity) AS sales19
  FROM fact_ev_sales f JOIN dim_state s ON f.state_id=s.state_id
  JOIN dim_date d ON f.date_id=d.date_id
  WHERE d.year=2019 GROUP BY s.state
),
y23 AS (
  SELECT s.state, SUM(f.ev_sales_quantity) AS sales23
  FROM fact_ev_sales f JOIN dim_state s ON f.state_id=s.state_id
  JOIN dim_date d ON f.date_id=d.date_id
  WHERE d.year=2023 GROUP BY s.state
)
SELECT y19.state, 
  ROUND((POWER(sales23::numeric / NULLIF(sales19,0), 1.0/4) - 1) * 100, 1) AS cagr_pct
FROM y19 JOIN y23 ON y19.state = y23.state
WHERE sales19 > 500
ORDER BY cagr_pct DESC LIMIT 5;

-- 10. Top 10 States by Absolute Sales
SELECT s.state, SUM(f.ev_sales_quantity) AS total_sales
FROM fact_ev_sales f JOIN dim_state s ON f.state_id = s.state_id
GROUP BY s.state
ORDER BY total_sales DESC LIMIT 10;
