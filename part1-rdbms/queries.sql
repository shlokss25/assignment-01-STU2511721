-- ============================================
-- BASIC QUERIES (Exploration)
-- ============================================

SELECT * FROM Customers;

SELECT product_name, price
FROM Products;

SELECT o.order_id, c.name, o.order_date
FROM Orders o
JOIN Customers c
ON o.customer_id = c.customer_id;

SELECT o.order_id, p.product_name, oi.quantity
FROM Order_Items oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id;

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name;


-- ============================================
-- ADVANCED ANALYTICAL QUERIES (Assignment)
-- ============================================

-- Q1: Customers from Mumbai + total order value
SELECT 
    c.name,
    SUM(oi.quantity * oi.price) AS total_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE c.city = 'Mumbai'
GROUP BY c.name;


-- Q2: Top 3 products by quantity sold
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 3;


-- Q3: Sales reps and unique customers handled
SELECT 
    s.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM Sales_Reps s
JOIN Orders o ON s.sales_rep_id = o.sales_rep_id
GROUP BY s.sales_rep_name;


-- Q4: Orders above 10,000 sorted by value
SELECT 
    o.order_id,
    SUM(oi.quantity * oi.price) AS total_value
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING total_value > 10000
ORDER BY total_value DESC;


-- Q5: Products never ordered
SELECT 
    p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;