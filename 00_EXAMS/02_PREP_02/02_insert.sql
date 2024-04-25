INSERT INTO clients(full_name, phone_number)

SELECT
    concat(first_name, ' ', last_name) as full_name,
    concat('(088) 9999', id * 2) as phone_number
FROM
    drivers
WHERE
    id BETWEEN 10 AND 20

RETURNING *;

