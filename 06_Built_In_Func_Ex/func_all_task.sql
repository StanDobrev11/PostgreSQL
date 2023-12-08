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
