BEGIN;

UPDATE coaches
SET
    salary = salary * coach_level
WHERE
    id =
        (SELECT
            coach_id
        FROM
            coaches AS c
            JOIN
                players_coaches AS pc ON pc.coach_id = c.id
        WHERE
            LEFT(first_name, 1) = 'C'
        GROUP BY
            coach_id);