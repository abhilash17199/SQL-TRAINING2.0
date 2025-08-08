
CREATE DATABASE task2db;
USE task2db;


-- Create Customers table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(50) DEFAULT 'Unknown'
);

-- Create Products table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    quantity INT DEFAULT 1,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Payments table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50) DEFAULT 'Cash',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- INSERT Customers
INSERT INTO Customers (name, email, phone, city) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', 'New York'),
('Bob Smith', 'bob@example.com', NULL, NULL),
('Charlie Brown', NULL, '9988776655', 'Chicago');

-- INSERT Products
INSERT INTO Products (name, price, stock) VALUES
('Laptop', 1200.00, 10),
('Mouse', 25.00, 100),
('Keyboard', 45.00, 50);

-- INSERT Orders
INSERT INTO Orders (customer_id, product_id, quantity, status) VALUES
(1, 1, 1, 'Shipped'),
(2, 2, 2, NULL),
(3, 3, NULL, 'Cancelled');

-- INSERT Payments
INSERT INTO Payments (order_id, amount, method) VALUES
(1, 1200.00, 'Credit Card'),
(2, NULL, NULL);

-- -------------------------------
-- UPDATE Handling NULLs
-- -------------------------------

-- Set default city where city is NULL
UPDATE Customers
SET city = 'Default City'
WHERE city IS NULL;

-- Set default quantity in Orders
UPDATE Orders
SET quantity = 1
WHERE quantity IS NULL;

-- Set default status in Orders
UPDATE Orders
SET status = 'Pending'
WHERE status IS NULL;

-- Update missing amount in Payments based on price * quantity
UPDATE Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Products pr ON o.product_id = pr.product_id
SET p.amount = o.quantity * pr.price
WHERE p.amount IS NULL;

-- Set default method to 'Cash'
UPDATE Payments
SET method = 'Cash'
WHERE method IS NULL;

-- -------------------------------
-- DELETE Invalid Records
-- -------------------------------

-- Delete Customers without email
DELETE FROM Customers
WHERE email IS NULL;

-- Delete Payments with zero or negative amount
DELETE FROM Payments
WHERE amount <= 0;

-- -------------------------------
-- Final SELECTs
-- -------------------------------
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Payments;
