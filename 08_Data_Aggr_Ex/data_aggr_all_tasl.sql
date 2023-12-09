------------------------------------------------------------
--01. COUNT of Records
SELECT
    count(*)
FROM
    wizard_deposits;
------------------------------------------------------------
--02. Total Deposit Amount
SELECT
    sum(deposit_amount) AS total_amount
FROM
    wizard_deposits;
------------------------------------------------------------
--03. AVG Magic Wand Size
SELECT
    round(avg(magic_wand_size), 3) AS average_magic_wand_size
FROM
    wizard_deposits;
------------------------------------------------------------
--04. MIN Deposit Charge
SELECT
    min(deposit_charge) AS minimum_deposit_charge
FROM
    wizard_deposits;
------------------------------------------------------------
--05. MAX Age
SELECT
    max(age) AS maximum_age
FROM
    wizard_deposits;
------------------------------------------------------------
--06. GROUP BY Deposit Interest
SELECT
    deposit_group,
    sum(deposit_interest) AS total_amount
FROM
    wizard_deposits
GROUP BY
    deposit_group
ORDER BY
    total_amount DESC;
------------------------------------------------------------
--07. LIMIT the Magic Wand Creator
SELECT
    magic_wand_creator,
    min(magic_wand_size) AS minimum_wand_size
FROM
    wizard_deposits
GROUP BY
    magic_wand_creator
ORDER BY
    minimum_wand_size ASC
LIMIT 5;
------------------------------------------------------------
--08. Bank Profitability
SELECT
    deposit_group,
    is_deposit_expired,
    floor(avg(deposit_interest)) AS deposit_interest
FROM
    wizard_deposits
WHERE
    deposit_start_date > '1985-01-01'
GROUP BY
    deposit_group, is_deposit_expired
ORDER BY
    deposit_group DESC,
    is_deposit_expired ASC;
------------------------------------------------------------
--09. Notes with Dumbledore
SELECT
    last_name,
    count(notes) AS notes_with_dumbledore
FROM
    wizard_deposits
WHERE
    notes LIKE '%Dumbledore%'
GROUP BY
    last_name;
------------------------------------------------------------
--10 Wizard View
CREATE VIEW
    view_wizard_deposits_with_expiration_date_before_1983_08_17 AS
SELECT
    concat(first_name, ' ', last_name) AS "Wizard Name",
    deposit_start_date AS "Start Date",
    deposit_expiration_date AS "Expiration Date",
    deposit_amount AS "Amount"
FROM
    wizard_deposits
WHERE
    deposit_expiration_date <= '1983-08-17'
GROUP BY
    "Wizard Name",
    "Start Date",
    "Expiration Date",
    "Amount"
ORDER BY
    deposit_expiration_date ASC;
------------------------------------------------------------
--11. Filter Max Deposit
SELECT
    magic_wand_creator,
    max(deposit_amount) AS max_deposit_amount
FROM
    wizard_deposits
GROUP BY
    magic_wand_creator
HAVING
    max(deposit_amount) > 40000
       OR
    max(deposit_amount) < 20000
ORDER BY
    max_deposit_amount DESC
LIMIT 3;
------------------------------------------------------------
--12. Age Group
SELECT
    CASE
        WHEN age <= 10 THEN '[0-10]'
        WHEN age <= 20 THEN '[11-20]'
        WHEN age <= 30 THEN '[21-30]'
        WHEN age <= 40 THEN '[31-40]'
        WHEN age <= 50 THEN '[41-50]'
        WHEN age <= 60 THEN '[51-60]'
        ELSE '[61+]'
    END AS age_group,
    count(age)
FROM
    wizard_deposits
GROUP BY
    age_group
ORDER BY
    age_group ASC;
------------------------------------------------------------
-- softuni_management_db in use
--13. SUM the Employees
SELECT
    COUNT(CASE department_id WHEN 1 THEN 1 END) AS "Engineering",
    COUNT(CASE department_id WHEN 2 THEN 1 END) AS "Tool Design",
    COUNT(CASE department_id WHEN 3 THEN 1 END) AS "Sales",
    COUNT(CASE department_id WHEN 4 THEN 1 END) AS "Marketing",
    COUNT(CASE department_id WHEN 5 THEN 1 END) AS "Purchasing",
    COUNT(CASE department_id WHEN 6 THEN 1 END) AS "Research and Development",
    COUNT(CASE department_id WHEN 7 THEN 1 END) AS "Production"
FROM
    employees;
------------------------------------------------------------
--14. Update Employees’ Data
UPDATE
    employees
SET
    salary =
        CASE
            WHEN hire_date < '2015-01-16' THEN salary + 2500
            WHEN hire_date < '2020-03-04' THEN salary + 1500
            ELSE salary
        END,
    job_title =
        CONCAT(
            CASE
                WHEN hire_date < '2015-01-16' THEN 'Senior '
                WHEN hire_date < '2020-03-04' THEN 'Mid-'
            END,
            job_title
            )
RETURNING *
;
------------------------------------------------------------
--15. Categorizes Salary
SELECT
    job_title,
    CASE
        WHEN avg(salary) > 45800 THEN 'Good'
        WHEN avg(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
        ELSE 'Need Improvement'
    END AS category
FROM
    employees
GROUP BY
    job_title
ORDER BY
    category ASC,
    job_title ASC
;
------------------------------------------------------------
--16. WHERE Project Status
SELECT
    project_name,
    CASE
        WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
        WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
        ELSE 'Done'
    END AS project_status
FROM
    projects
WHERE
    project_name LIKE '%Mountain%'
;
------------------------------------------------------------
--17. HAVING Salary Level
SELECT
    department_id,
    count(department_id) AS num_employees,
    CASE
        WHEN avg(salary) > 50000 THEN 'Above average'
        WHEN avg(salary) <= 50000 THEN 'Below average'
    END AS salary_level
FROM
    employees
GROUP BY
    department_id
HAVING
    avg(salary) > 30000
ORDER BY
    department_id, salary_level
;
------------------------------------------------------------
-- 18 Nested CASE Conditions
CREATE VIEW
    view_performance_rating AS
SELECT
    first_name,
    last_name,
    job_title,
    salary,
    department_id,
    CASE
        WHEN salary >= 25000 THEN
            CASE
                WHEN job_title LIKE 'Senior%' THEN 'High-performing Senior'
                WHEN job_title NOT LIKE 'Senior%' THEN 'High-performing Employee'
            END
        ELSE 'Average-performing'
    END AS performance_rating
FROM
    employees
;
------------------------------------------------------------
--19 Foreign Key
CREATE TABLE
    employees_projects (
        "id" SERIAL PRIMARY KEY,
        employee_id INTEGER,
        project_id INTEGER,

        FOREIGN KEY (employee_id) REFERENCES employees(id),
        FOREIGN KEY (project_id) REFERENCES projects(id)
    );
------------------------------------------------------------
--20 Join Tables
SELECT
    *
FROM
    departments AS d
JOIN
    employees AS e ON
        d.id = e.department_id
;
