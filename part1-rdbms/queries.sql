-- Advanced queries

-- Q1: Customers from Mumbai and their total order value
SELECT c.name,
       SUM(oi.quantity * p.price) AS total_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE c.city = 'Mumbai'
GROUP BY c.name;


-- Q2: Top 3 products based on quantity sold
SELECT p.product_name,
       SUM(oi.quantity) AS total_quantity
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 3;


-- Q3: Sales reps and number of unique customers handled
-- (assuming Sales_Reps table exists)
SELECT s.sales_rep_name,
       COUNT(DISTINCT o.customer_id) AS unique_customers
FROM Sales_Reps s
JOIN Orders o ON s.sales_rep_id = o.sales_rep_id
GROUP BY s.sales_rep_name;


-- Q4: Orders where total value is more than 10000
SELECT o.order_id,
       SUM(oi.quantity * p.price) AS total_value
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * p.price) > 10000
ORDER BY total_value DESC;


-- Q5: Products that were never ordered
SELECT p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;