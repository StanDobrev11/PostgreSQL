BEGIN
-------------------------------------------------------
-- SHOWING DATA AS ALIAS
SELECT
    first_name AS new_alias,
    last_name AS "SELECT" -- double quotes to escape special word
FROM table_name
-------------------------------------------------------
-- RETRIEVING DATA
-- select specific columns
SELECT (col_name, col_name1...) FROM table_name
-------------------------------------------------------
-- 01. Select Employee Information
SELECT
    id,
    concat(first_name, ' ', last_name) AS full_name,
    job_title AS "Job Title"
FROM employees;
-------------------------------------------------------
-- 02. Select Employees by Filtering
SELECT
    job_title,
    salary
FROM employees
ORDER BY salary DESC;
-------------------------------------------------------
SELECT DISTINCT first_name -- DISTINCT removes duplicates on first_name
FROM employees;
-------------------------------------------------------
SELECT DISTINCT
    first_name,
    last_name -- DISTINCT works on both should be distinct
FROM employees;
-------------------------------------------------------
SELECT DISTINCT ON (last_name)  -- DISTINCT on specific column
    first_name,
    last_name
FROM employees;
-------------------------------------------------------
SELECT
    id,
    concat(first_name, ' ', last_name) AS full_name,
    job_title,
    salary
FROM employees
WHERE salary > 1000.00
ORDER BY id;
-------------------------------------------------------
SELECT
    id,
    concat(first_name, ' ', last_name) AS full_name,
    job_title,
    salary
FROM employees
WHERE department_id = 3;
-------------------------------------------------------
--03. Select Employees by Multiple Filters
-- comparison: >, <, = -> ==, <> -> !=, >=, <=
-- logical operators - IN, NOT IN, BETWEEN, AND, OR
SELECT
    id,
    first_name,
    last_name,
    job_title,
    department_id,
    salary
FROM employees
WHERE
    salary BETWEEN 1000 AND 1500
ORDER BY id;
-------------------------------------------------------
SELECT
    id,
    first_name,
    last_name,
    job_title,
    department_id,
    salary
FROM employees
WHERE
    department_id = 4
    OR
    salary >= 1100
ORDER BY id;
-------------------------------------------------------
SELECT
    id,
    first_name,
    last_name,
    job_title,
    department_id,
    salary
FROM employees
WHERE
    department_id = 4
    AND
    salary >= 1000
ORDER BY id;
-------------------------------------------------------
SELECT * FROM clients
WHERE last_name IS NULL; -- should use always IS because = returns False
-------------------------------------------------------
-- 04. Insert Data into Employees Table
INSERT INTO employees (
    first_name,
    last_name,
    job_title,
    department_id,
    salary)
VALUES
    ('Samantha', 'Young', 'Housekeeping', 4, 900),
    ('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * FROM employees;
-------------------------------------------------------
-- insert from table
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30)
);

INSERT INTO test_table (first_name, last_name)
SELECT
    first_name,
    last_name
FROM
    employees
RETURNING first_name, last_name; -- confirm record has been completed
-------------------------------------------------------
CREATE TABLE test_table
AS
SELECT
    id,
    first_name,
    last_name
FROM
    employees;
-------------------------------------------------------
-- 05. Update Salary and Select
UPDATE employees
SET salary = salary + 100
WHERE employees.job_title = 'Manager';

SELECT * FROM employees
WHERE job_title = 'Manager';
-------------------------------------------------------
UPDATE clients
SET last_name = 'Unknown'
WHERE
    last_name IS NULL
RETURNING *;
-------------------------------------------------------
-- 06. Delete from Table
DELETE FROM employees
WHERE department_id IN (1, 2);

SELECT * FROM employees
ORDER BY id;
-------------------------------------------------------
-- 07. Top Paid Employee View
-- VIEW is used to create different tables mixins which are used often, but only as view
CREATE VIEW top_paid_employee AS
SELECT
    id,
    first_name,
    last_name,
    job_title,
    department_id,
    salary
FROM
    employees
WHERE
    salary = (SELECT MAX(salary) FROM employees);
SELECT * FROM top_paid_employee;