SELECT
    concat(o.name, ' - ', a.name) AS "Owners - Animals",
    o.phone_number AS "Phone Number",
    ac.cage_id AS "Cage ID"
FROM
    owners AS o
    JOIN
        animals AS a ON a.owner_id = o.id
        JOIN
            animals_cages AS ac ON a.id = ac.animal_id
WHERE
    a.animal_type_id = 1
ORDER BY
    o.name ASC,
    a.name DESC;