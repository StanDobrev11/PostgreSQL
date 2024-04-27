SELECT
    clients.full_name,
    count(cars) as count_of_cars,
    sum(courses.bill) as total_sum
FROM
    clients
JOIN courses on clients.id = courses.client_id
JOIN cars on courses.car_id = cars.id
WHERE
    SUBSTRING(clients.full_name, 2, 1) = 'a'
GROUP BY
    clients.full_name
HAVING
    count(cars) > 1
ORDER BY
    clients.full_name
;

SELECT
    clients.full_name,
    count(courses.car_id) as count_of_cars,
    sum(courses.bill) as total_sum
FROM
    clients
JOIN courses on clients.id = courses.client_id
WHERE
    SUBSTRING(clients.full_name, 2, 1) = 'a'
GROUP BY
    clients.full_name
HAVING
    count(courses.car_id) > 1
ORDER BY
    clients.full_name
;