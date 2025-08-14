-- Create Database
CREATE DATABASE task6db;
USE task6db;


--  Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50),
    join_date DATE,
    loyalty_points INT DEFAULT 0,
    vip_status ENUM('Regular', 'Silver', 'Gold', 'Platinum') DEFAULT 'Regular'
);

--  Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    order_date DATE,
    payment_status ENUM('Pending', 'Completed', 'Refunded'),
    shipping_status ENUM('Processing', 'Shipped', 'Delivered', 'Returned'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert Customers
INSERT INTO Customers (name, email, phone, city, join_date, loyalty_points, vip_status) VALUES
('Alice Johnson', 'alice@example.com', '9876543210', 'New York', '2024-01-10', 120, 'Silver'),
('Bob Smith', 'bob@example.com', '9988776655', 'Los Angeles', '2024-02-15', 200, 'Gold'),
('Charlie Lee', 'charlie@example.com', '9876123456', 'Chicago', '2024-03-05', 50, 'Regular'),
('Diana Prince', 'diana@example.com', '9911223344', 'Miami', '2024-04-20', 300, 'Platinum');

--  Insert Orders
INSERT INTO Orders (customer_id, product_name, category, amount, order_date, payment_status, shipping_status) VALUES
(1, 'Smartphone', 'Electronics', 699.99, '2024-05-01', 'Completed', 'Delivered'),
(2, 'Laptop', 'Electronics', 1200.00, '2024-05-10', 'Completed', 'Delivered'),
(2, 'Headphones', 'Electronics', 199.99, '2024-06-15', 'Pending', 'Processing'),
(3, 'Coffee Maker', 'Home Appliances', 89.50, '2024-06-20', 'Completed', 'Delivered'),
(4, 'Smartwatch', 'Electronics', 299.00, '2024-07-01', 'Completed', 'Shipped');

----------------------------------------------------
-- Subquery in SELECT (Scalar Subquery)
-- Find each customer's total spending
----------------------------------------------------
SELECT 
    name,
    email,
    vip_status,
    (SELECT SUM(amount) 
     FROM Orders 
     WHERE Orders.customer_id = Customers.customer_id) AS total_spent
FROM Customers;

----------------------------------------------------
-- Subquery in WHERE (IN)
-- Find customers who bought Electronics products
----------------------------------------------------
SELECT name, email, city
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM Orders
    WHERE category = 'Electronics'
);

----------------------------------------------------
-- Subquery in WHERE (EXISTS)
-- Find VIP customers who have at least one completed order
----------------------------------------------------
SELECT name, email, vip_status
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
    AND o.payment_status = 'Completed'
)
AND vip_status IN ('Gold', 'Platinum');

----------------------------------------------------
-- Subquery in FROM (Derived Table)
-- Find top 2 highest spenders
----------------------------------------------------
SELECT name, total_spent
FROM (
    SELECT c.name, SUM(o.amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.name
) AS spending_data
ORDER BY total_spent DESC
LIMIT 2;

----------------------------------------------------
-- Correlated Subquery
-- Find orders that are above customer's average spending
----------------------------------------------------
SELECT o.order_id, o.product_name, o.amount, c.name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.amount > (
    SELECT AVG(amount)
    FROM Orders
    WHERE customer_id = o.customer_id
);

----------------------------------------------------
-- Real-life Feature:
-- Find customers eligible for free shipping (Total spend > 500)
----------------------------------------------------
SELECT name, email, total_spent
FROM (
    SELECT c.name, c.email, SUM(o.amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS spending_summary
WHERE total_spent > 500;
