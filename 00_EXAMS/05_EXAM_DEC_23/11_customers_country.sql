CREATE OR REPLACE PROCEDURE sp_customer_country_name(
    IN customer_full_name VARCHAR(50),
    OUT country_name VARCHAR(50))
AS
$$
BEGIN
    country_name :=
            (SELECT countries.name
             FROM countries
                      JOIN customers ON countries.id = customers.country_id
             WHERE
                 CONCAT(customers.first_name, ' ', customers.last_name) LIKE customer_full_name);
END
$$ LANGUAGE plpgsql;

CALL sp_customer_country_name('Betty Wallace', '');
CALL sp_customer_country_name('Rachel Bishop', '');