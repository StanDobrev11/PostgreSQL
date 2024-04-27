SELECT
    *
FROM
    cars
LEFT JOIN courses on cars.id = courses.car_id
ORDER BY
    cars.id;




SELECT
    cars.id,
    cars.make,
    cars.mileage,
    count(courses) as count_of_courses,
    round(avg(bill), 2) as average_bill
FROM
    cars

LEFT JOIN
    courses ON cars.id = courses.car_id

GROUP BY
    cars.id, cars.make, cars.mileage
HAVING
    count(courses) != 2
ORDER BY
    count_of_courses DESC ,
    cars.id
;
