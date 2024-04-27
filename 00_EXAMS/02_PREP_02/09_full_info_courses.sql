SELECT
    addresses.name AS address,
    CASE
        WHEN extract(HOUR FROM courses.start) BETWEEN 6 AND 20 THEN 'Day'
        WHEN extract(HOUR FROM courses.start) BETWEEN 21 AND 23
            OR extract(HOUR FROM courses.start) BETWEEN 0 AND 5 THEN 'Night'
    END AS day_time,
    courses.bill,
    clients.full_name,
    cars.make,
    cars.model,
    categories.name AS category_name
FROM
    courses
JOIN addresses ON courses.from_address_id = addresses.id
JOIN clients ON courses.client_id = clients.id
JOIN cars ON courses.car_id = cars.id
JOIN categories on cars.category_id = categories.id
ORDER BY
    courses.id
;
