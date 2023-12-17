BEGIN;

INSERT INTO
    coaches(first_name, last_name, salary, coach_level)
SELECT
    first_name,
    last_name,
    (salary * 2) as salary,
    LENGTH(first_name) AS coach_level
FROM
    players
WHERE
    hire_date < '2013-12-13 07:18:46'
RETURNING *
;

ALTER SEQUENCE coaches_id_seq RESTART WITH 11;


SELECT last_value + increment_by AS next_value
FROM pg_sequences
WHERE sequencename = 'coaches_id_seq';
