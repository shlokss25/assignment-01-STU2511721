/*
Part 3 — Data Warehouse Analytical Queries (OLAP)

These queries are designed to perform analytical operations
on the star schema (fact_sales + dimensions).
*/


-- ======================================================
-- Q1: Total Sales Revenue by Product Category for Each Month
-- ======================================================

SELECT 
    dp.category,
    dd.year,
    dd.month,
    SUM(fs.total_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY dp.category, dd.year, dd.month
ORDER BY dd.year, dd.month, total_revenue DESC;



-- ======================================================
-- Q2: Top 2 Performing Stores by Total Revenue
-- ======================================================

SELECT 
    ds.store_name,
    SUM(fs.total_amount) AS total_revenue
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.store_name
ORDER BY total_revenue DESC
LIMIT 2;



-- ======================================================
-- Q3: Month-over-Month Sales Trend Across All Stores
-- ======================================================

SELECT 
    dd.year,
    dd.month,
    SUM(fs.total_amount) AS monthly_revenue,
    LAG(SUM(fs.total_amount)) OVER (ORDER BY dd.year, dd.month) AS previous_month_revenue,
    (SUM(fs.total_amount) - LAG(SUM(fs.total_amount)) OVER (ORDER BY dd.year, dd.month)) 
        AS revenue_change
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;