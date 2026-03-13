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