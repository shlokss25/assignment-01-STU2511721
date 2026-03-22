-- ============================================================
-- Part 3 — Analytical Queries (Data Warehouse)
-- ============================================================

-- Q1: Total sales revenue by product category for each month
SELECT
    dd.year,
    dd.month_num,
    dd.month_name,
    dp.category,
    SUM(fs.total_revenue)  AS total_revenue,
    SUM(fs.units_sold)     AS total_units_sold,
    COUNT(fs.sale_id)      AS num_transactions
FROM fact_sales  fs
JOIN dim_date    dd ON fs.date_key    = dd.date_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dd.year, dd.month_num, dd.month_name, dp.category
ORDER BY dd.year, dd.month_num, dp.category;

-- Q2: Top 2 performing stores by total revenue
SELECT
    ds.store_name,
    ds.store_city,
    ds.store_region,
    SUM(fs.total_revenue)  AS total_revenue,
    SUM(fs.units_sold)     AS total_units_sold,
    COUNT(fs.sale_id)      AS num_transactions
FROM fact_sales fs
JOIN dim_store  ds ON fs.store_key = ds.store_key
GROUP BY ds.store_key, ds.store_name, ds.store_city, ds.store_region
ORDER BY total_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
-- Uses a self-join approach to compute current vs previous month revenue
WITH monthly_revenue AS (
    SELECT
        dd.year,
        dd.month_num,
        dd.month_name,
        SUM(fs.total_revenue) AS revenue
    FROM fact_sales fs
    JOIN dim_date   dd ON fs.date_key = dd.date_key
    GROUP BY dd.year, dd.month_num, dd.month_name
),
mom_trend AS (
    SELECT
        curr.year,
        curr.month_num,
        curr.month_name,
        curr.revenue                                   AS current_month_revenue,
        prev.revenue                                   AS previous_month_revenue,
        ROUND(curr.revenue - COALESCE(prev.revenue, 0), 2)
                                                       AS revenue_change,
        CASE
            WHEN prev.revenue IS NULL OR prev.revenue = 0 THEN NULL
            ELSE ROUND(
                ((curr.revenue - prev.revenue) / prev.revenue) * 100,
                2
            )
        END                                            AS mom_growth_percent
    FROM monthly_revenue curr
    LEFT JOIN monthly_revenue prev
        ON  prev.year      = curr.year
        AND prev.month_num = curr.month_num - 1
)
SELECT
    year,
    month_num,
    month_name,
    current_month_revenue,
    previous_month_revenue,
    revenue_change,
    mom_growth_percent,
    CASE
        WHEN mom_growth_percent > 0  THEN 'Growth'
        WHEN mom_growth_percent < 0  THEN 'Decline'
        WHEN mom_growth_percent = 0  THEN 'Flat'
        ELSE 'First Month'
    END AS trend_direction
FROM mom_trend
ORDER BY year, month_num;
