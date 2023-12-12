--01

SELECT
    t.town_id,
    t.name AS town_name,
    a.address_text
FROM
    addresses AS a
        JOIN towns AS t USING (town_id)
WHERE
    t.name in ('San Francisco', 'Sofia', 'Carnation')
ORDER BY
    t.town_id,
    a.address_id
;

--02
SELECT
    e.employee_id,
    concat_ws(' ', e.first_name, e.last_name) AS full_name,
    d.department_id,
    d.name
FROM
    employees AS e
        JOIN departments AS d ON e.employee_id = d.manager_id
ORDER BY
    e.employee_id
LIMIT 5
;

--03
SELECT
    e.employee_id,
    concat_ws(' ', e.first_name, e.last_name) AS full_name,
    p.project_id,
    p.name
FROM
    employees AS e
        JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
        JOIN projects AS p ON ep.project_id = p.project_id
GROUP BY
    e.employee_id,
    full_name,
    p.project_id,
    p.name
HAVING
    p.project_id = 1
;

--04
SELECT
    count(*)
FROM
    employees
WHERE
    salary > (SELECT avg(salary) FROM employees)
;