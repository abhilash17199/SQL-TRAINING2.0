CREATE DATABASE task5db;
USE task5db;

-- ==================================
-- Create Customers table
-- ==================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50),
    join_date DATE,
    loyalty_points INT DEFAULT 0
);

-- ==================================
-- Create Orders table
-- ==================================
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    order_date DATE,
    payment_status ENUM('Pending','Completed','Refunded'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ==================================
-- Insert sample customers
-- ==================================
INSERT INTO Customers (customer_id, name, email, phone, city, join_date, loyalty_points) VALUES
(1, 'Alice Johnson', 'alice@example.com', '9876543210', 'New York', '2023-02-15', 150),
(2, 'Bob Smith', 'bob@example.com', '8765432109', 'Los Angeles', '2023-05-10', 80),
(3, 'Charlie Lee', 'charlie@example.com', '7654321098', 'Chicago', '2023-06-20', 200),
(4, 'David Brown', 'david@example.com', '6543210987', 'Miami', '2023-07-01', 0),
(5, 'Eva Adams', 'eva@example.com', '5432109876', 'Boston', '2023-08-11', 300);

-- ==================================
-- Insert sample orders
-- ==================================
INSERT INTO Orders (order_id, customer_id, product_name, category, amount, order_date, payment_status) VALUES
(101, 1, 'MacBook Air', 'Electronics', 1200.00, '2023-03-01', 'Completed'),
(102, 1, 'Wireless Mouse', 'Accessories', 25.00, '2023-03-05', 'Completed'),
(103, 2, 'Mechanical Keyboard', 'Accessories', 75.00, '2023-05-15', 'Refunded'),
(104, 3, 'Office Chair', 'Furniture', 300.00, '2023-07-12', 'Completed'),
(105, 6, 'Smartphone', 'Electronics', 900.00, '2023-08-05', 'Pending'); -- No matching customer

-- ==============================================================
-- INNER JOIN - Customers with at least one order
-- Use case: Customer purchase history
-- ==============================================================
SELECT 
    c.customer_id,
    c.name,
    c.email,
    o.product_name,
    o.category,
    o.amount,
    o.payment_status,
    o.order_date
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

-- ==============================================================
-- LEFT JOIN - All customers and their orders if available
-- Use case: Identify inactive customers (NULL orders)
-- ==============================================================
SELECT 
    c.customer_id,
    c.name,
    c.email,
    o.product_name,
    o.amount,
    IF(o.product_name IS NULL, 'No Orders', 'Has Orders') AS order_status
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- ==============================================================
-- RIGHT JOIN - All orders and their customers if available
-- Use case: Detect orders with missing customer profiles
-- ==============================================================
SELECT 
    o.order_id,
    o.product_name,
    o.amount,
    o.payment_status,
    c.customer_id,
    c.name
FROM Customers c
RIGHT JOIN Orders o
    ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- ==============================================================
-- FULL OUTER JOIN - All customers and all orders
-- Use case: Combine both LEFT and RIGHT join data
-- ==============================================================
SELECT 
    c.customer_id,
    c.name,
    o.product_name,
    o.amount,
    o.payment_status
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id

UNION

SELECT 
    c.customer_id,
    c.name,
    o.product_name,
    o.amount,
    o.payment_status
FROM Customers c
RIGHT JOIN Orders o
    ON c.customer_id = o.customer_id
ORDER BY customer_id;
