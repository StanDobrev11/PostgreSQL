CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
    INOUT animal_name VARCHAR(30)
    )
AS $$
DECLARE
    animal VARCHAR;
BEGIN
    animal := animal_name;
    animal_name :=
        (SELECT
            o.name
        FROM
            owners AS o
            JOIN
                animals AS a ON a.owner_id = o.id
        WHERE
            a.name = animal);

    IF animal_name IS NULL THEN
        animal_name := 'For adoption';
    END IF;

END
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
    IN animal_name VARCHAR(30),
    OUT owner_or_not VARCHAR
    )
AS $$
--DECLARE
--    animal VARCHAR;
BEGIN
--    animal := animal_name;
    owner_or_not :=
        (SELECT
            o.name
        FROM
            owners AS o
            JOIN
                animals AS a ON a.owner_id = o.id
        WHERE
            a.name = animal_name);

    IF owner_or_not IS NULL THEN
        owner_or_not := 'For adoption';
    END IF;

END
$$ LANGUAGE plpgsql;

CALL sp_animals_with_owners_or_not('Pumpkinseed Sunfish', null);