/*
Part 3 — Data Warehouse Star Schema
This schema organizes retail order data for analytical queries.
It follows a proper star schema with correct granularity.
*/


-- --------------------------------------------------
-- Dimension Table: Customers
-- --------------------------------------------------

CREATE TABLE DimCustomer (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100)
);


-- --------------------------------------------------
-- Dimension Table: Products
-- --------------------------------------------------

CREATE TABLE DimProduct (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);


-- --------------------------------------------------
-- Dimension Table: Date
-- (Enhanced for better analytics)
-- --------------------------------------------------

CREATE TABLE DimDate (
    date_id DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    quarter INT,              -- Optional Upgrade
    weekday VARCHAR(10)       -- Optional Upgrade
);


-- --------------------------------------------------
-- Dimension Table: Order Status
-- --------------------------------------------------

CREATE TABLE DimStatus (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
);


-- --------------------------------------------------
-- Fact Table: Order Items (Correct Granularity)
-- Each row represents ONE product in ONE order
-- --------------------------------------------------

CREATE TABLE FactOrderItems (
    order_item_id INT PRIMARY KEY,
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    date_id DATE,
    status_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),

    FOREIGN KEY (customer_id) REFERENCES DimCustomer(customer_id),
    FOREIGN KEY (product_id) REFERENCES DimProduct(product_id),
    FOREIGN KEY (date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (status_id) REFERENCES DimStatus(status_id)
);