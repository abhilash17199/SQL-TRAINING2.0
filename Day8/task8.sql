CREATE DATABASE task8db;
USE task8db;

-- 1. Create employees table with real-life fields
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    joining_date DATE
);

-- 2. Stored Procedure: Add employee with bonus logic based on department
DELIMITER //-- 

CREATE PROCEDURE AddEmployeeWithBonus (
    IN emp_name VARCHAR(100),
    IN emp_dept VARCHAR(50),
    IN emp_salary DECIMAL(10, 2),
    IN emp_joining DATE
)
BEGIN
    DECLARE bonus DECIMAL(10, 2);

    -- Add conditional bonus
    IF emp_dept = 'Engineering' THEN
        SET bonus = 10000;
    ELSEIF emp_dept = 'HR' THEN
        SET bonus = 5000;
    ELSE
        SET bonus = 2000;
    END IF;

    INSERT INTO employees (name, department, salary, joining_date)
    VALUES (emp_name, emp_dept, emp_salary + bonus, emp_joining);
END //

DELIMITER ;

-- 3. Call the procedure (with bonus logic applied)
CALL AddEmployeeWithBonus('Abhilash Rout', 'Engineering', 60000.00, '2023-01-10');
CALL AddEmployeeWithBonus('Riya Sen', 'HR', 50000.00, '2023-02-15');
CALL AddEmployeeWithBonus('John Paul', 'Marketing', 45000.00, '2023-03-01');

-- 4. Function: Classify employee based on salary
DELIMITER //

CREATE FUNCTION GetEmployeeLevel (
    emp_salary DECIMAL(10, 2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE emp_level VARCHAR(20);

    IF emp_salary >= 80000 THEN
        SET emp_level = 'Senior';
    ELSEIF emp_salary >= 50000 THEN
        SET emp_level = 'Mid-Level';
    ELSE
        SET emp_level = 'Junior';
    END IF;

    RETURN emp_level;
END //

DELIMITER ;

-- 5. Use the function in a SELECT to view employee levels
SELECT 
    name, 
    department, 
    salary,
    GetEmployeeLevel(salary) AS level,
    joining_date
FROM employees;
