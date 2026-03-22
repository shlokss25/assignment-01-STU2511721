-- ============================================================
-- Part 1 — Schema Design (3NF)
-- ============================================================

-- Drop tables in reverse dependency order (for re-runnability)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sales_reps;

-- ============================================================
-- TABLE: sales_reps
-- Stores one row per sales representative.
-- Eliminates update anomaly: office_address is stored once.
-- ============================================================
CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  NOT NULL,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) NOT NULL UNIQUE,
    office_address VARCHAR(255) NOT NULL,
    CONSTRAINT pk_sales_reps PRIMARY KEY (sales_rep_id)
);

-- ============================================================
-- TABLE: customers
-- Stores one row per customer.
-- Eliminates delete anomaly: customers exist independently of orders.
-- ============================================================
CREATE TABLE customers (
    customer_id   VARCHAR(10)  NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL UNIQUE,
    customer_city VARCHAR(100) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

-- ============================================================
-- TABLE: products
-- Stores one row per product.
-- Eliminates insert anomaly: products can be added without orders.
-- ============================================================
CREATE TABLE products (
    product_id   VARCHAR(10)  NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

-- ============================================================
-- TABLE: orders
-- Central fact table — one row per order line.
-- All non-key attributes depend solely on order_id (3NF).
-- ============================================================
CREATE TABLE orders (
    order_id     VARCHAR(10)  NOT NULL,
    customer_id  VARCHAR(10)  NOT NULL,
    product_id   VARCHAR(10)  NOT NULL,
    quantity     INT          NOT NULL CHECK (quantity > 0),
    order_date   DATE         NOT NULL,
    sales_rep_id VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_orders      PRIMARY KEY (order_id),
    CONSTRAINT fk_ord_cust    FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    CONSTRAINT fk_ord_prod    FOREIGN KEY (product_id)   REFERENCES products(product_id),
    CONSTRAINT fk_ord_srep    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- ============================================================
-- INSERT: sales_reps (all 3 reps from the dataset)
-- ============================================================
INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');

-- ============================================================
-- INSERT: customers (8 customers from dataset)
-- ============================================================
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta', 'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma','priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',  'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',  'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh','vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',  'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',  'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',   'kavya@gmail.com',  'Hyderabad');

-- ============================================================
-- INSERT: products (all 8 products from dataset)
-- ============================================================
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00);

-- ============================================================
-- INSERT: orders (10 representative rows from the dataset)
-- ============================================================
INSERT INTO orders (order_id, customer_id, product_id, quantity, order_date, sales_rep_id) VALUES
('ORD1027', 'C002', 'P004', 4,  '2023-11-02', 'SR02'),
('ORD1114', 'C001', 'P007', 2,  '2023-08-06', 'SR01'),
('ORD1002', 'C002', 'P005', 1,  '2023-01-17', 'SR02'),
('ORD1091', 'C001', 'P006', 3,  '2023-07-24', 'SR01'),
('ORD1061', 'C006', 'P001', 4,  '2023-10-27', 'SR01'),
('ORD1098', 'C007', 'P001', 2,  '2023-10-03', 'SR03'),
('ORD1075', 'C005', 'P003', 3,  '2023-04-18', 'SR03'),
('ORD1076', 'C004', 'P006', 5,  '2023-05-16', 'SR03'),
('ORD1185', 'C003', 'P008', 1,  '2023-06-15', 'SR03'),
('ORD1169', 'C003', 'P003', 5,  '2023-01-28', 'SR01');
