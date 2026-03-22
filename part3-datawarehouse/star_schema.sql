-- ============================================================
-- Part 3 — Star Schema Design (Data Warehouse)
-- Source data: retail_transactions.csv
-- ============================================================

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- ============================================================
-- DIMENSION: dim_date
-- Date dimension with pre-computed calendar attributes for
-- fast GROUP BY operations without string parsing at query time.
-- ============================================================
CREATE TABLE dim_date (
    date_key     INT          NOT NULL,   -- Surrogate key: YYYYMMDD
    full_date    DATE         NOT NULL,
    day_of_week  VARCHAR(10)  NOT NULL,
    day_num      INT          NOT NULL,   -- 1=Monday ... 7=Sunday
    week_num     INT          NOT NULL,
    month_num    INT          NOT NULL,
    month_name   VARCHAR(10)  NOT NULL,
    quarter      INT          NOT NULL,
    year         INT          NOT NULL,
    is_weekend   BOOLEAN      NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_key)
);

-- ============================================================
-- DIMENSION: dim_store
-- One row per physical store location.
-- ============================================================
CREATE TABLE dim_store (
    store_key    INT          NOT NULL AUTO_INCREMENT,
    store_name   VARCHAR(100) NOT NULL,
    store_city   VARCHAR(100) NOT NULL,
    store_region VARCHAR(50)  NOT NULL,  -- e.g., South, West, North
    CONSTRAINT pk_dim_store PRIMARY KEY (store_key)
);

-- ============================================================
-- DIMENSION: dim_product
-- One row per product in the catalog.
-- ============================================================
CREATE TABLE dim_product (
    product_key      INT          NOT NULL AUTO_INCREMENT,
    product_name     VARCHAR(100) NOT NULL,
    category         VARCHAR(50)  NOT NULL,   -- Standardised: Electronics/Clothing/Grocery/Groceries
    unit_price       DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_key)
);

-- ============================================================
-- FACT TABLE: fact_sales
-- One row per transaction (grain = one retail transaction).
-- All foreign keys reference dimension surrogate keys.
-- ============================================================
CREATE TABLE fact_sales (
    sale_id         INT           NOT NULL AUTO_INCREMENT,
    date_key        INT           NOT NULL,
    store_key       INT           NOT NULL,
    product_key     INT           NOT NULL,
    transaction_id  VARCHAR(20)   NOT NULL,
    customer_id     VARCHAR(20)   NOT NULL,
    units_sold      INT           NOT NULL CHECK (units_sold > 0),
    unit_price      DECIMAL(10,2) NOT NULL,
    total_revenue   DECIMAL(12,2) NOT NULL,   -- Derived: units_sold * unit_price
    CONSTRAINT pk_fact_sales PRIMARY KEY (sale_id),
    CONSTRAINT fk_fs_date    FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    CONSTRAINT fk_fs_store   FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    CONSTRAINT fk_fs_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);

-- ============================================================
-- INSERT: dim_date (covering all months in 2023 used in the data)
-- ============================================================
INSERT INTO dim_date (date_key, full_date, day_of_week, day_num, week_num, month_num, month_name, quarter, year, is_weekend) VALUES
(20230101, '2023-01-01', 'Sunday',    7,  1,  1, 'January',   1, 2023, TRUE),
(20230115, '2023-01-15', 'Sunday',    7,  3,  1, 'January',   1, 2023, TRUE),
(20230205, '2023-02-05', 'Sunday',    7,  6,  2, 'February',  1, 2023, TRUE),
(20230220, '2023-02-20', 'Monday',    1,  8,  2, 'February',  1, 2023, FALSE),
(20230331, '2023-03-31', 'Friday',    5, 13,  3, 'March',     1, 2023, FALSE),
(20230418, '2023-04-18', 'Tuesday',   2, 16,  4, 'April',     2, 2023, FALSE),
(20230521, '2023-05-21', 'Sunday',    7, 21,  5, 'May',       2, 2023, TRUE),
(20230604, '2023-06-04', 'Sunday',    7, 23,  6, 'June',      2, 2023, TRUE),
(20230722, '2023-07-22', 'Saturday',  6, 30,  7, 'July',      3, 2023, TRUE),
(20230809, '2023-08-09', 'Wednesday', 3, 32,  8, 'August',    3, 2023, FALSE),
(20230829, '2023-08-29', 'Tuesday',   2, 35,  8, 'August',    3, 2023, FALSE),
(20230917, '2023-09-17', 'Sunday',    7, 38,  9, 'September', 3, 2023, TRUE),
(20231026, '2023-10-26', 'Thursday',  4, 43, 10, 'October',   4, 2023, FALSE),
(20231118, '2023-11-18', 'Saturday',  6, 47, 11, 'November',  4, 2023, TRUE),
(20231208, '2023-12-08', 'Friday',    5, 49, 12, 'December',  4, 2023, FALSE);

-- ============================================================
-- INSERT: dim_store (5 stores from dataset — NULL city cleaned to store default)
-- ============================================================
INSERT INTO dim_store (store_name, store_city, store_region) VALUES
('Chennai Anna',    'Chennai',   'South'),
('Bangalore MG',    'Bangalore', 'South'),
('Mumbai Central',  'Mumbai',    'West'),
('Delhi South',     'Delhi',     'North'),
('Pune FC Road',    'Pune',      'West');

-- ============================================================
-- INSERT: dim_product (all products from dataset — category standardised to Title Case)
-- ============================================================
INSERT INTO dim_product (product_name, category, unit_price) VALUES
('Speaker',      'Electronics',  49262.78),
('Tablet',       'Electronics',  23226.12),
('Phone',        'Electronics',  48703.39),
('Smartwatch',   'Electronics',  58851.01),
('Laptop',       'Electronics',  42343.15),
('Headphones',   'Electronics',  39854.96),
('Jeans',        'Clothing',      2317.47),
('Jacket',       'Clothing',     30187.24),
('Saree',        'Clothing',     35451.81),
('T-Shirt',      'Clothing',     29770.19),
('Atta 10kg',    'Grocery',      52464.00),
('Milk 1L',      'Grocery',      43374.39),
('Pulses 1kg',   'Grocery',      31604.47),
('Rice 5kg',     'Grocery',      52195.05),
('Biscuits',     'Grocery',      27469.99),
('Oil 1L',       'Grocery',      26474.34);

-- ============================================================
-- INSERT: fact_sales
-- 15 cleaned rows from retail_transactions.csv
-- Transformations applied:
--   1. Date normalised to YYYY-MM-DD (from DD/MM/YYYY and DD-MM-YYYY variants)
--   2. category standardised: 'electronics' -> 'Electronics', 'Groceries' -> 'Grocery'
--   3. NULL store_city rows: city inferred from store_name (e.g. 'Chennai Anna' -> 'Chennai')
--   4. total_revenue = units_sold * unit_price (computed column)
-- ============================================================
INSERT INTO fact_sales (date_key, store_key, product_key, transaction_id, customer_id, units_sold, unit_price, total_revenue) VALUES
(20230829, 1, 1, 'TXN5000', 'CUST045',  3, 49262.78,  147788.34),  -- Chennai Anna, Speaker
(20231208, 1, 2, 'TXN5001', 'CUST021', 11, 23226.12,  255487.32),  -- Chennai Anna, Tablet
(20230205, 1, 3, 'TXN5002', 'CUST019', 20, 48703.39,  974067.80),  -- Chennai Anna, Phone
(20230220, 4, 2, 'TXN5003', 'CUST007', 14, 23226.12,  325165.68),  -- Delhi South, Tablet
(20230115, 1, 4, 'TXN5004', 'CUST004', 10, 58851.01,  588510.10),  -- Chennai Anna, Smartwatch
(20230809, 2, 11,'TXN5005', 'CUST027', 12, 52464.00,  629568.00),  -- Bangalore MG, Atta
(20230331, 5, 4, 'TXN5006', 'CUST025',  6, 58851.01,  353106.06),  -- Pune FC Road, Smartwatch
(20231026, 5, 7, 'TXN5007', 'CUST041', 16,  2317.47,   37079.52),  -- Pune FC Road, Jeans
(20231208, 2,15, 'TXN5008', 'CUST030',  9, 27469.99,  247229.91),  -- Bangalore MG, Biscuits
(20230917, 2, 4, 'TXN5009', 'CUST020',  3, 58851.01,  176553.03),  -- Bangalore MG, Smartwatch
(20230604, 1, 9, 'TXN5010', 'CUST031', 15, 35451.81,  531777.15),  -- Chennai Anna, Saree (was Jacket raw→correct)
(20230521, 2, 5, 'TXN5012', 'CUST044', 13, 42343.15,  550461.95),  -- Bangalore MG, Laptop
(20230418, 3,12, 'TXN5013', 'CUST015', 10, 43374.39,  433743.90),  -- Mumbai Central, Milk
(20231118, 4, 8, 'TXN5014', 'CUST042',  5, 30187.24,  150936.20),  -- Delhi South, Jacket
(20230809, 3,11, 'TXN5033', 'CUST017',  8, 52464.00,  419712.00);  -- Mumbai Central, Atta (NULL city → Mumbai)
