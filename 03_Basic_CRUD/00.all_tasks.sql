BEGIN

-- SHOWING DATA AS ALIAS
SELECT
    first_name AS new_alias,
    last_name AS "SELECT" -- double quotes to escape special word
FROM table_name

-- RETRIEVING DATA
-- select specific columns
SELECT (col_name, col_name1...) FROM table_name

-- 01. Select Employee Information
SELECT
    id,
    concat(first_name, ' ', last_name) AS "Full Name",
    job_title AS "Job Title"
FROM employees;

-- 02. Select Employees by Filtering

