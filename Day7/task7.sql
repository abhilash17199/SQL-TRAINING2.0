-- Create Database
CREATE DATABASE task7db;
USE task7db;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE,
    loyalty_points INT DEFAULT 0,
    vip_status ENUM('Regular','Silver','Gold','Platinum') DEFAULT 'Regular'
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    order_date DATE,
    payment_status ENUM('Pending','Completed','Refunded') DEFAULT 'Pending',
    shipping_status ENUM('Processing','Shipped','Delivered','Returned') DEFAULT 'Processing',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert Sample Customers
INSERT INTO Customers (name, email, city, join_date, loyalty_points, vip_status) VALUES
('John Doe', 'john@example.com', 'New York', '2023-01-15', 150, 'Silver'),
('Jane Smith', 'jane@example.com', 'Los Angeles', '2023-03-10', 350, 'Gold'),
('Michael Brown', 'mike@example.com', 'Chicago', '2023-05-05', 50, 'Regular'),
('Emily Davis', 'emily@example.com', 'Houston', '2023-07-20', 800, 'Platinum');

-- Insert Sample Orders
INSERT INTO Orders (customer_id, product_name, category, amount, order_date, payment_status, shipping_status) VALUES
(1, 'iPhone 14', 'Electronics', 1200.00, '2023-08-01', 'Completed', 'Delivered'),
(1, 'AirPods Pro', 'Electronics', 250.00, '2023-08-10', 'Completed', 'Delivered'),
(2, 'MacBook Pro', 'Electronics', 2400.00, '2023-08-15', 'Completed', 'Shipped'),
(3, 'Running Shoes', 'Sportswear', 120.00, '2023-09-01', 'Pending', 'Processing'),
(4, '4K TV', 'Electronics', 1600.00, '2023-09-05', 'Completed', 'Processing'),
(4, 'Wireless Keyboard', 'Electronics', 90.00, '2023-09-07', 'Completed', 'Delivered');

-- Customer Purchase Summary View
CREATE VIEW customer_purchase_summary AS
SELECT 
    c.customer_id,
    c.name,
    c.city,
    c.vip_status,
    COUNT(o.order_id) AS total_orders,
    IFNULL(SUM(o.amount),0) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city, c.vip_status;

-- High-Value Orders View
CREATE VIEW high_value_orders AS
SELECT 
    o.order_id,
    o.product_name,
    o.amount,
    c.name AS customer_name,
    c.city
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.amount > 1000;

-- Pending Shipments View
CREATE VIEW pending_shipments AS
SELECT 
    o.order_id,
    o.product_name,
    o.shipping_status,
    c.name AS customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.shipping_status IN ('Processing', 'Shipped');

-- Secure Customer View (Hide Sensitive Data)
CREATE VIEW secure_customer_view AS
SELECT 
    customer_id,
    name,
    city,
    vip_status
FROM Customers;

--- Usage Examples
-- View all purchase summaries
SELECT * FROM customer_purchase_summary;

-- View all high-value orders
SELECT * FROM high_value_orders;

-- View all pending shipments
SELECT * FROM pending_shipments;

-- View only non-sensitive customer data
SELECT * FROM secure_customer_view;
