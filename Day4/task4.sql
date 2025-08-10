
CREATE DATABASE task4db;
USE task4db;
-- ===============================
-- 1. Create the orders table
-- ===============================
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product TEXT NOT NULL,
    category TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price REAL NOT NULL,
    order_date DATE NOT NULL
);

-- ===============================
-- 2. Insert sample data
-- ===============================
INSERT INTO orders (order_id, customer_id, product, category, quantity, price, order_date) VALUES
(1, 101, 'Laptop',    'Electronics', 2, 60000, '2025-08-01'),
(2, 102, 'Mouse',     'Electronics', 5,   500, '2025-08-02'),
(3, 101, 'Keyboard',  'Electronics', 3,  1500, '2025-08-02'),
(4, 103, 'Monitor',   'Electronics', 1, 12000, '2025-08-03'),
(5, 102, 'Laptop',    'Electronics', 1, 60000, '2025-08-04'),
(6, 104, 'Chair',     'Furniture',   4,  3000, '2025-08-04'),
(7, 101, 'Desk',      'Furniture',   1,  8000, '2025-08-05');

-- ===============================
-- 3. Queries
-- ===============================

-- 3.1 Monthly Sales Summary
-- SQLite: strftime, MySQL: DATE_FORMAT(order_date, '%Y-%m')
SELECT 
    strftime('%Y-%m', order_date) AS month,
    SUM(quantity * price) AS total_sales,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY month
ORDER BY month;

-- 3.2 Top 3 Best-Selling Products
SELECT 
    product, 
    SUM(quantity) AS total_units_sold
FROM orders
GROUP BY product
ORDER BY total_units_sold DESC
LIMIT 3;

-- 3.3 Average Spend per Customer
SELECT 
    customer_id, 
    ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id), 2) AS avg_spend_per_order
FROM orders
GROUP BY customer_id;

-- 3.4 Category-wise Revenue
SELECT 
    category, 
    SUM(quantity * price) AS category_revenue
FROM orders
GROUP BY category
ORDER BY category_revenue DESC;

-- 3.5 Customers Who Bought Multiple Categories
SELECT 
    customer_id,
    COUNT(DISTINCT category) AS categories_bought
FROM orders
GROUP BY customer_id
HAVING categories_bought > 1;
