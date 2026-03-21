/*
Part 3 — Data Warehouse Queries

Basic analytical queries on star schema
*/

-- Q1: revenue by category per month
SELECT dp.category,
       dd.year,
       dd.month,
       SUM(fs.total_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY dp.category, dd.year, dd.month
ORDER BY dd.year, dd.month;


-- Q2: top 2 stores by revenue
SELECT ds.store_name,
       SUM(fs.total_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.store_name
ORDER BY total_revenue DESC
LIMIT 2;


-- Q3: month over month sales trend
WITH monthly_sales AS (
    SELECT dd.year,
           dd.month,
           SUM(fs.total_amount) AS monthly_revenue
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dd.year, dd.month
)

SELECT year,
       month,
       monthly_revenue,
       LAG(monthly_revenue) OVER (ORDER BY year, month) AS prev_month,
       (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month)) AS revenue_change
FROM monthly_sales
ORDER BY year, month;