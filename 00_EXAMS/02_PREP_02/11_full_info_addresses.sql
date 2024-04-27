DROP TABLE IF EXISTS search_results;
CREATE TABLE search_results
(
    id SERIAL PRIMARY KEY,
    address_name  VARCHAR(100),
    full_name VARCHAR(50),
    level_of_bill VARCHAR(6),
    make          VARCHAR(20),
    condition     CHAR(1),
    category_name VARCHAR(10)
);

CREATE OR REPLACE PROCEDURE sp_courses_by_address(IN address_name VARCHAR(100))
AS
$$
BEGIN
    TRUNCATE TABLE search_results;
    INSERT INTO search_results(
                               address_name,
                               full_name,
                               level_of_bill,
                               make,
                               condition,
                               category_name
    )
    SELECT addresses.name,
           clients.full_name,
           CASE
               WHEN courses.bill <= 20 THEN 'Low'
               WHEN courses.bill <= 30 THEN 'Medium'
               ELSE 'High'
               END         AS level_of_bill,
           cars.make,
           cars.condition,
           categories.name
    FROM addresses
             JOIN courses ON addresses.id = courses.from_address_id
             JOIN clients ON courses.client_id = clients.id
             JOIN cars ON courses.car_id = cars.id
             JOIN categories ON cars.category_id = categories.id
    WHERE addresses.name = address_name
    ORDER BY
        cars.make,
        clients.full_name;
END
$$ language plpgsql;

CALL sp_courses_by_address('700 Monterey Avenue');
CALL sp_courses_by_address('66 Thompson Drive');

SELECT * FROM search_results;
