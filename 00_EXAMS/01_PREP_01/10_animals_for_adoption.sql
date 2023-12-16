SELECT
    a.name AS animal,
    to_char(a.birthdate, 'YYYY') AS birth_year,
    atp.animal_type
FROM
    animals AS a
    JOIN
        animal_types AS atp ON a.animal_type_id = atp.id
WHERE
    atp.animal_type NOT LIKE '%Birds'
        AND
    a.birthdate >= '2017-01-01'::date
        AND
    a.owner_id IS NULL
ORDER BY
    a.name ASC;