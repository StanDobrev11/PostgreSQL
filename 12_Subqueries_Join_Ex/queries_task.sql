--01 Booked for Nights

SELECT
    concat(a.address, ' ', a.address_2) AS apartment_address,
    b.booked_for AS nights
FROM
    bookings AS b
        JOIN apartments AS a USING (booking_id)
ORDER BY
    a.apartment_id;

-- 02 First 10 Apartments Booked At

SELECT
    name,
    country,
    booked_at::date
FROM
    apartments LEFT JOIN
        bookings USING (booking_id)
LIMIT 10;

-- 03 First 10 Customers with Bookings
SELECT
    booking_id,
    starts_at::date,
    apartment_id,
    concat(first_name, ' ', last_name) AS customer_name
FROM
    bookings RIGHT JOIN
        customers USING (customer_id)
ORDER BY
    customer_name
LIMIT 10
;

--04. Booking Information
SELECT
    b.booking_id,
    a.name AS apartment_owner,
    a.apartment_id,
    concat(c.first_name, ' ', c.last_name) AS customer_name
FROM
    bookings AS b
        FULL JOIN
            apartments AS a USING (booking_id)
        FULL JOIN
            customers as c USING (customer_id)
ORDER BY
    b.booking_id ASC,
    apartment_owner ASC,
    customer_name
;
--05. Multiplication of Information

SELECT
    booking_id,
    first_name
FROM
    bookings,
    customers
ORDER BY
    first_name
LIMIT 20;

SELECT
    booking_id,
    first_name
FROM
    bookings CROSS JOIN customers
ORDER BY
    first_name
LIMIT 20;

--06. Unassigned Apartments

SELECT
    booking_id,
    apartment_id,
    companion_full_name
FROM
    bookings JOIN
        customers USING (customer_id)
WHERE
    apartment_id IS null
;
--07. Bookings Made by Lead

SELECT
    apartment_id,
    booked_for,
    first_name,
    country
FROM
    bookings JOIN
        customers USING (customer_id)
WHERE
    job_type LIKE '%Lead%'
;
--08. Hahn's Bookings

SELECT
    count(*)
FROM
    bookings JOIN
        customers USING (customer_id)
WHERE
    last_name LIKE '%Hahn'
;
--09. Total Sum of Nights

SELECT
    name,
    sum(booked_for) AS sum
FROM
    apartments JOIN
        bookings USING (apartment_id)
GROUP BY
    name
ORDER BY
    name
;

--10. Popular Vacation Destination
SELECT
    country,
    count(bookings.booking_id) AS booking_count
FROM
    apartments JOIN
        bookings USING (apartment_id)
WHERE
    bookings.booked_at > '2021-05-18 07:52:09.904+03'
            AND
    bookings.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY
    country
ORDER BY
    booking_count DESC
;



-------------------------------------
--geography_db
--11. Bulgaria's Peaks Higher than 2835 Meters

SELECT
    country_code,
    mountain_range,
    peak_name,
    elevation
FROM
    mountains_countries
        JOIN
            peaks USING (mountain_id)
        JOIN
            mountains ON mountain_id = mountains.id
WHERE
    country_code = 'BG'
        AND
    elevation > 2835
ORDER BY
    elevation DESC
;
--12. Count Mountain Ranges
SELECT
    country_code,
    count(mountain_id) AS mountain_range_count
FROM
    mountains_countries
GROUP BY
    country_code
HAVING
    country_code IN ('US', 'RU', 'BG')
ORDER BY
    mountain_range_count DESC
;
--13. Rivers in Africa
SELECT
    country_name,
    river_name
FROM
    countries
        LEFT JOIN
            countries_rivers USING (country_code)
        LEFT JOIN
            rivers ON river_id = rivers.id
WHERE
    continent_code = 'AF'
GROUP BY
    country_name,
    river_name
ORDER BY
    country_name
LIMIT 5
;

--14. Minimum Average Area Across Continents
SELECT
    min(average_area)
FROM
    (SELECT
        avg(area_in_sq_km) AS average_area
    FROM
        countries
    GROUP BY
        continent_code) AS subquery;
;
--15. Countries Without Any Mountains

SELECT
    count(country_code) AS countries_without_mountains
FROM
    mountains_countries RIGHT JOIN
        countries USING (country_code)
WHERE
    mountain_id IS NULL
    ;
--16. Monasteries by Country
CREATE TABLE
    monasteries (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    monastery_name VARCHAR(255),
    country_code CHAR(2),

    CONSTRAINT fk_monasteries_countries
        FOREIGN KEY (country_code)
            REFERENCES countries(country_code)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

INSERT INTO
    monasteries (monastery_name, country_code)
VALUES
    ('Rila Monastery "St. Ivan of Rila"', 'BG'),
    ('Bachkovo Monastery "Virgin Mary"', 'BG'),
    ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
    ('Kopan Monastery', 'NP'),
    ('Thrangu Tashi Yangtse Monastery', 'NP'),
    ('Shechen Tennyi Dargyeling Monastery', 'NP'),
    ('Benchen Monastery', 'NP'),
    ('Southern Shaolin Monastery', 'CN'),
    ('Dabei Monastery', 'CN'),
    ('Wa Sau Toi', 'CN'),
    ('Lhunshigyia Monastery', 'CN'),
    ('Rakya Monastery', 'CN'),
    ('Monasteries of Meteora', 'GR'),
    ('The Holy Monastery of Stavronikita', 'GR'),
    ('Taung Kalat Monastery', 'MM'),
    ('Pa-Auk Forest Monastery', 'MM'),
    ('Taktsang Palphug Monastery', 'BT'),
    ('Sumela Monastery', 'TR');

ALTER TABLE
    countries
ADD COLUMN
    three_rivers BOOLEAN DEFAULT FALSE
;

UPDATE
    countries AS c
SET
    three_rivers = TRUE
WHERE
    c.country_code IN
    (SELECT
        country_code
    FROM
        countries_rivers
    GROUP BY
        country_code
    HAVING
        count(river_id) >= 3)
;

SELECT
    monastery_name AS monastery,
    country_name AS country
FROM
    monasteries
        JOIN
            countries USING (country_code)
WHERE
    three_rivers IS FALSE
ORDER BY
    monastery_name ASC
;

--17. Monasteries by Continents and Countries
UPDATE
    countries
SET
    country_name = 'Burma',
    country_code = 'BU'
WHERE
    country_name = 'Myanmar'
;

INSERT INTO
    monasteries (monastery_name, country_code)
VALUES
    ('Hanga Abbey', 'TZ')
--    ('Myin-Tin-Daik', 'MM') -- ERROR WHEN THIS IS COMPLETED
;

SELECT
    continent_name,
    country_name,
    count(monastery_name) AS monasteries_count
FROM
    continents
        LEFT JOIN
            countries USING (continent_code)
        LEFT JOIN
            monasteries USING (country_code)
WHERE
    three_rivers IS FALSE
GROUP BY
    continent_name,
    country_name
ORDER BY
    monasteries_count DESC,
    country_name ASC
;


--18. Retrieving Information about Indexes
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename ASC,
    indexname ASC;

--19
CREATE VIEW
    continent_currency_usage AS
SELECT
    continent_code,
    currency_code,
    count(currency_code) AS currency_usage,
    DENSE_RANK() OVER (PARTITION BY count(currency_code) ORDER BY continent_code ASC)
FROM
    countries
GROUP BY
    continent_code,
    currency_code
HAVING
    count(currency_code) > 1
;

--20
SELECT
    peak_name,
    elevation,
    mountain_range
FROM
    peaks
        JOIN
            mountains USING