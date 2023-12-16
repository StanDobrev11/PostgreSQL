SELECT
    name,
    animal_type,
    to_char(birthdate, 'DD.MM.YYYY') AS birthdate
FROM
    animals
    JOIN
        animal_types ON animal_type_id = animal_types.id
ORDER BY
    name;