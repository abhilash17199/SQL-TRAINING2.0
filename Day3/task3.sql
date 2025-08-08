-- ===========================================
-- TASK 3: BASIC & ADVANCED SELECT QUERIES
-- ===========================================
CREATE DATABASE task3db;
USE task3db;

-- 1. Create sample table
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name TEXT,
    department TEXT,
    salary INTEGER,
    join_date DATE
);

-- 2. Insert sample data
INSERT INTO employees (name, department, salary, join_date) VALUES
('Alice', 'IT', 60000, '2024-01-15'),
('Bob', 'Finance', 55000, '2023-09-20'),
('Charlie', 'IT', 70000, '2024-05-10'),
('David', 'HR', 45000, '2023-12-05'),
('Eva', 'Finance', 65000, '2024-03-17'),
('Frank', 'Finance', 50000, '2024-07-11'),
('Grace', 'IT', 72000, '2025-02-01'),
('Hannah', 'HR', 48000, '2025-01-12'),
('Ian', 'Marketing', 53000, '2024-08-21'),
('Jack', 'IT', 68000, '2025-03-03');

-- ===========================================
-- BASIC SELECT QUERIES
-- ===========================================

-- Get all columns
SELECT * FROM employees;

-- Get specific columns
SELECT name, salary FROM employees;

-- WHERE: Filter rows
SELECT * FROM employees
WHERE department = 'IT';

-- WHERE with AND
SELECT name, salary, department
FROM employees
WHERE salary > 50000 AND department = 'Finance';

-- WHERE with BETWEEN
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 70000;

-- WHERE with LIKE
SELECT * FROM employees
WHERE name LIKE 'A%'; -- Names starting with A

-- ORDER BY DESC
SELECT name, salary
FROM employees
ORDER BY salary DESC;

-- ORDER BY multiple columns
SELECT name, department, salary
FROM employees
ORDER BY department ASC, salary ASC;

-- LIMIT
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- ===========================================
-- EXTENDED FUNCTIONALITY
-- ===========================================

-- DISTINCT
SELECT DISTINCT department
FROM employees;

-- ALIAS
SELECT name AS EmployeeName, salary AS MonthlySalary
FROM employees AS e;

-- COUNT & GROUP BY
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department;

-- AVG with GROUP BY
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- HAVING (filter groups)
SELECT department, COUNT(*) AS total
FROM employees
GROUP BY department
HAVING COUNT(*) > 2;

-- IN operator
SELECT name, department
FROM employees
WHERE department IN ('IT', 'Finance');

-- DATE Filtering (MySQL syntax)
-- For SQLite use: strftime('%Y', join_date) = '2024'
SELECT name, join_date
FROM employees
WHERE YEAR(join_date) = 2024;

-- LIMIT with OFFSET (pagination)
SELECT *
FROM employees
ORDER BY id ASC
LIMIT 5 OFFSET 5;

-- Subquery
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
