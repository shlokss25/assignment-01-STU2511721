/*
Part 3 — Star Schema Design
*/


-- ================================
-- DIMENSION TABLES
-- ================================

CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);


-- ================================
-- FACT TABLE
-- ================================

CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    date_id DATE,
    store_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),

    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);


-- ================================
-- INSERT CLEANED DATA
-- ================================

-- dim_date
INSERT INTO dim_date VALUES
('2023-05-01', 2023, 5, 1),
('2023-05-02', 2023, 5, 2),
('2023-05-03', 2023, 5, 3);

-- dim_store
INSERT INTO dim_store VALUES
(1, 'Mumbai Store', 'Mumbai'),
(2, 'Delhi Store', 'Delhi');

-- dim_product (cleaned category casing)
INSERT INTO dim_product VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Shoes', 'Fashion'),
(103, 'Mobile', 'Electronics');


-- ================================
-- FACT TABLE (10+ CLEAN ROWS)
-- ================================

INSERT INTO fact_sales VALUES
(1, '2023-05-01', 1, 101, 1, 50000),
(2, '2023-05-01', 1, 102, 2, 4000),
(3, '2023-05-02', 2, 103, 1, 20000),
(4, '2023-05-02', 1, 101, 1, 52000),
(5, '2023-05-03', 2, 102, 3, 6000),
(6, '2023-05-03', 1, 103, 2, 40000),
(7, '2023-05-01', 2, 101, 1, 51000),
(8, '2023-05-02', 1, 102, 1, 2000),
(9, '2023-05-03', 2, 103, 1, 21000),
(10, '2023-05-01', 1, 101, 2, 100000);