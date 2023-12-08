-------------------------------------------------------------
-- 01 River info
CREATE VIEW
    view_river_info AS
SELECT
    concat(
    'The river', ' ', river_name, ' ',
    'flows into the', ' ', outflow, ' ',
    'and is', ' ', "length", ' ', 'kilometers long.'
    )
    AS "River Information"
FROM
    rivers
ORDER BY
    river_name;
-------------------------------------------------------------
-- 02 Concatenate Geography Data
CREATE VIEW
    view_continents_countries_currencies_details AS
SELECT
    concat(con.continent_name, ': ', con.continent_code) AS "Continent Details",
    concat_ws(' - ',cou.country_name, cou.capital, cou.area_in_sq_km, 'km2') AS "Country Information",
    concat(cur.description, ' (', cur.currency_code, ')') AS "Currencies"
FROM
    continents AS con,
    countries AS cou,
    currencies AS cur
WHERE
    con.continent_code = cou.continent_code
        AND
    cur.currency_code = cou.currency_code
ORDER BY
    "Country Information" ASC,
    "Currencies" ASC;
-------------------------------------------------------------
-- 03 Capital Code
ALTER TABLE
    countries
ADD COLUMN
    capital_code CHAR(2);

UPDATE
    countries
SET
    capital_code = substring(capital, 1, 2);
-------------------------------------------------------------
-- 04 (Descr)iption
SELECT
--    substring(description FROM 5)
    right(description, -4)
FROM
    currencies;
-------------------------------------------------------------
-- 05 Substring River Length
SELECT
--    (REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_length
    substring("River Information", '([0-9]{1,4})') AS river_length
FROM
    view_river_info;
-------------------------------------------------------------
-- 06. Replace A
SELECT
    replace("mountain_range", 'a', '@') AS replace_a,
    replace("mountain_range", 'A', '$') AS replace_A
FROM
    mountains;
-------------------------------------------------------------
--07. Translate
SELECT
    capital,
    translate(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM
    countries;


-- CHECK DB ENCODING
SELECT
    datname,
    datcollate
FROM
    pg_database
WHERE
    datname = 'geography_db';

-- CHECK TABLE ENCODING
SELECT
    table_name,
    column_name,
    character_maximum_length,
    character_set_name,
    collation_name
FROM
    information_schema.columns
WHERE
    table_name = 'countries'
        AND
    column_name = 'capital';

-- SET CLIENT ENCODING TO UTF-8
SET client_encoding TO 'UTF8';
SET client_encoding TO 'WIN1252';

-- VIEW ENCODING
\encoding

--This query identifies rows where the capital column contains non-UTF-8 characters.
SELECT
    id
    capital
FROM
    countries
WHERE
    LENGTH(capital) <> LENGTH(convert_to(capital, 'UTF8'));
--update to encoded using the UTF-8 extended ASCII representation rather than the expected UTF-8 encoding.
UPDATE countries
SET capital = convert_from(convert_to(capital, 'UTF8'), 'UTF8');
-------------------------------------------------------------
-- 8. LEADING
SELECT
    continent_name,
--    TRIM(LEADING FROM continent_name) AS trimmed_name
    LTRIM(continent_name) AS trimmed_name
FROM
    continents;
-------------------------------------------------------------
--09. TRAILING
SELECT
    continent_name,
--    TRIM(TRAILING FROM continent_name) AS trimmed_name
    RTRIM(continent_name) AS trimmed_name
--    TRIM(continent_name) AS trimmed_name
FROM
    continents;
-------------------------------------------------------------
-- 10. LTRIM & RTRIM
SELECT
    LTRIM(peak_name, 'M') AS "Left Trim",
    RTRIM(peak_name, 'm') AS "Right Trim"
FROM
    peaks;
-------------------------------------------------------------
-- 11 Character Length and Bits
SELECT
    concat(m.mountain_range, ' ', p.peak_name) AS "Mountain Information",
    length(concat(m.mountain_range, ' ', p.peak_name)) AS "Characters Length",
    bit_length(concat(m.mountain_range, ' ', p.peak_name)) AS "Bits of a String"
FROM
    mountains AS m,
    peaks AS p
WHERE
    m.id = p.mountain_id;
-------------------------------------------------------------
-- 12 Length of number
SELECT
    population,
    length(cast(population AS VARCHAR))
FROM
    countries;
-------------------------------------------------------------
-- 13 Positive and Negative LEFT
SELECT
    peak_name,
    left(peak_name, 4) AS "Positive Left",
    left(peak_name, -4) AS "Negative Left"
FROM
    peaks;
-------------------------------------------------------------
--14. Positive and Negative RIGHT
SELECT
    peak_name,
    right(peak_name, 4) AS "Positive Right",
    right(peak_name, -4) AS "Negative Right"
FROM
    peaks;
-------------------------------------------------------------
--15. Update iso_code
UPDATE
    countries
SET
    iso_code = UPPER(LEFT(country_name, 3))
WHERE
    iso_code is NULL;
-------------------------------------------------------------
-- 16. REVERSE country_code
UPDATE
    countries
SET
    country_code = REVERSE(LOWER(country_code));
-------------------------------------------------------------
--17. Elevation --->> Peak Name
SELECT
    concat(elevation, ' ', repeat('-', 3), repeat('>', 2), ' ', peak_name) AS "Elevation --->> Peak Name"
FROM
    peaks
WHERE
    elevation >= 4884;
-------------------------------------------------------------
-- 18 Arithmetical Operators
-- booking_db
CREATE TABLE
    bookings_calculation AS
SELECT
    booked_for,
    CAST(booked_for * 50 AS NUMERIC) AS multiplication,
    CAST(booked_for % 50 AS NUMERIC) AS modulo
FROM
    bookings
WHERE
    apartment_id = 93;
-------------------------------------------------------------
-- 19 ROUND vs TRUNC
SELECT
    latitude,
    round(latitude, 2) AS round,
    trunc(latitude, 2) AS trunc
FROM
    apartments;
-------------------------------------------------------------
-- 20. Absolute Value
SELECT
    longitude,
    abs(longitude)
FROM
    apartments;
-------------------------------------------------------------
-- 21. Billing Day**
ALTER TABLE
    bookings
ADD COLUMN
    billing_day TIMESTAMPTZ DEFAULT NOW();

--SELECT
--    billing_day
--FROM
--    bookings

SELECT
    to_char(billing_day, 'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS') AS "Billing Day"
FROM
    bookings;
-----------------------------------------------------------
--22. EXTRACT Booked At
SELECT
    to_char(booked_at, 'YYYY') AS "YEAR",
    to_char(booked_at, 'MM') AS "MONTH",
    to_char(booked_at, 'DD') AS "DAY",
    to_char(booked_at AT TIME ZONE 'UTC', 'HH') AS "HOUR",
    to_char(booked_at, 'MM') AS "MINUTE",
    ceil(CAST(to_char(booked_at, 'SS') AS NUMERIC)) AS "SECOND"
FROM
    bookings;

SELECT
    extract(YEAR FROM booked_at) AS "YEAR",
    extract(MONTH FROM booked_at) AS "MONTH",
    extract(DAY FROM booked_at) AS "DAY",
    extract(HOUR FROM booked_at AT TIME ZONE 'UTC') AS "HOUR",
    extract(MINUTE FROM booked_at) AS "MINUTE",
    ceil(extract(SECOND FROM booked_at)) AS "SECOND"
FROM
    bookings;

SELECT
    id,
    booked_at,
    pg_typeof(booked_at) AS data_type,
    booked_at AT TIME ZONE 'UTC' AS converted_utc_value
FROM
    bookings;
-----------------------------------------------------------
--23. Early Birds
SELECT
    user_id,
    age(starts_at, booked_at) AS "Early Birds"
FROM
    bookings
WHERE
    starts_at - booked_at > '10 MONTH';
-----------------------------------------------------------
-- 24 . EXTRACT Booked At
SELECT
    companion_full_name,
    email
FROM
    users
WHERE
    companion_full_name iLIKE '%aNd%'
        AND
    email NOT LIKE '%@gmail';
-----------------------------------------------------------
-- 25COUNT by Initial
SELECT
    LEFT(first_name, 2) AS initials,
    COUNT('initials') AS user_count
FROM
    users
GROUP BY
    initials
ORDER BY
    user_count DESC,
    initials ASC;
-----------------------------------------------------------
-- 26 SUM
SELECT
    SUM(booked_for) AS total_value
FROM
    bookings
WHERE
    apartment_id = 90;
-----------------------------------------------------------
-- 27 AVERAGE
SELECT
    AVG(multiplication) AS total_value
FROM
    bookings_calculation;













