-- TRIM & TRANSLATE

SELECT
--    translate('1213121', '123', 'alb');
--    trim('    aassdd    '); -- there is trim left, right,
    trim('aassdd', 'd'); -- trims specific character


-- POSITION & SUBSTRING

CREATE TABLE
    authors_full_name AS
SELECT
    concat_ws(' ', first_name, last_name) AS "Full Name"
FROM
    authors;

SELECT
--    "Full Name",
    left("Full Name", position(' ' in "Full Name")) AS first_name,
    right("Full Name", length("Full Name") - position(' ' in "Full Name")) AS last_name,
    substring("Full Name", 1, position(' ' in "Full Name")) AS first_name,
    substring("Full Name", position(' ' in "Full Name"), length("Full Name")) AS first_name
FROM
    authors_full_name;

--          BASIC MATH FUNCTION
--    5 / 2; -- int division = 2 // in python
--    5::float / 2; -- float number = 2.5
--    cast(5 as float) / 2;
--    5 % 2; ---> mod(5, 2)
--    5 ^ 3; ---> pow(5, 3)
--    |/9; ---> sqrt(9)
--    @ -9; ---> abs(-9);
--    floor(3.2); - both work as in python
--    ceil(3.6);
--    round(2.2233422, 2); - as in python
--    trunc(2.334, 2) -- cuts till the provided value after the coma

-- BASIC DATE TIME OPERATIONS
SELECT
    extract('year' from now()) AS year ,     -- extracting year value
    extract('month' from now()) AS month,
    extract('day' from now()) AS day,
    extract('hour' from now()) AS hour,
    extract('minutes' from now()) AS minutes;

SELECT
    date_part('year',now()); --> only on post greSQL

SELECT
    age('2011-02-05', now()); --> returns difference

SELECT
    now() + INTERVAL '1 year 2 months 10 days 3 hours 40 minutes';

SELECT  -- to_char with datetime obj
    to_char(now(), 'YY'),
    to_char(now(), 'MMM'),
    to_char(now(), 'W') AS week_of_month,
    to_char(now(), 'WW') AS week_of_year,
    to_char(now(), 'DD');

-- LIKE

SELECT
    *
FROM
    authors
WHERE
    first_name LIKE '_gatha';

