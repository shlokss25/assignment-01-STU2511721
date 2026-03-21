-- Part 3: Star Schema Design (based on retail_transactions.csv)

-- =========================
-- Dimension Tables
-- =========================

-- date dimension
CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

-- store dimension
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50)
);

-- product dimension
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);


-- =========================
-- Fact Table
-- =========================

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


-- =========================
-- Insert Cleaned Data
-- =========================

-- dates (standardized format)
INSERT INTO dim_date VALUES
('2023-05-10', 2023, 5, 10),
('2023-05-11', 2023, 5, 11),
('2023-05-12', 2023, 5, 12),
('2023-05-13', 2023, 5, 13),
('2023-05-14', 2023, 5, 14);

-- stores (realistic names from dataset style)
INSERT INTO dim_store VALUES
(1, 'Reliance Digital', 'Mumbai'),
(2, 'Big Bazaar', 'Delhi'),
(3, 'DMart', 'Pune');

-- products (matching retail dataset)
INSERT INTO dim_product VALUES
(101, 'iPhone 13', 'Electronics'),
(102, 'Nike Running Shoes', 'Fashion'),
(103, 'Samsung TV', 'Electronics'),
(104, 'Jeans', 'Fashion');

-- fact table (based on transaction-like data)
INSERT INTO fact_sales VALUES
(1, '2023-05-10', 1, 101, 1, 70000),
(2, '2023-05-10', 2, 102, 2, 5000),
(3, '2023-05-11', 3, 104, 1, 2000),
(4, '2023-05-11', 1, 103, 1, 45000),
(5, '2023-05-12', 2, 102, 3, 7500),
(6, '2023-05-12', 3, 101, 1, 70000),
(7, '2023-05-13', 1, 104, 2, 4000),
(8, '2023-05-13', 2, 103, 1, 45000),
(9, '2023-05-14', 3, 102, 2, 5000),
(10,'2023-05-14', 1, 101, 1, 70000); 