SELECT
    d.first_name,
    d.last_name,
    c.make,
    c.model,
    c.mileage
FROM
    drivers as d
JOIN
    cars_drivers as cd ON d.id = cd.driver_id
JOIN
    cars as c on cd.car_id = c.id
WHERE
    mileage IS NOT NULL
ORDER BY
    c.mileage DESC,
    d.first_name
;
