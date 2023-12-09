-------------------------------------------------------
--01. Departments Info by ID
SELECT
    department_id,
    COUNT(department_id) AS employee_count
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
-- 02 Departments Info (by salary)
SELECT
    department_id,
    count(salary) AS employee_count
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
-- 03 Sum Salaries per Department
SELECT
    department_id,
    sum(salary) AS total_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
-- 04 Sum Salaries per Department
SELECT
    department_id,
    max(salary) AS max_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
--05 Minimum Salary per Department
SELECT
    department_id,
    min(salary) AS max_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
--06 Avg Salary per Department
SELECT
    department_id,
    avg(salary) AS max_salary
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id;
-------------------------------------------------------
--07 Filter Total Salaries
SELECT
    department_id,
    sum(salary) AS "Total Salary"
FROM
    employees
GROUP BY
    department_id
HAVING
    sum(salary) < 4200
ORDER BY
    department_id
;
-------------------------------------------------------
--8. Department Names
SELECT
    id,
    first_name,
    last_name,
    round(salary, 2),
    department_id,
    CASE department_id
        WHEN 1 THEN 'Management'
        WHEN 2 THEN 'Kitchen Staff'
        WHEN 3 THEN 'Service Staff'
        ELSE 'Other'
    END AS department_name
FROM
    employees;













