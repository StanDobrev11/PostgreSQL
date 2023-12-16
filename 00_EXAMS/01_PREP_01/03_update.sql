ALTER SEQUENCE animals_id_seq RESTART WITH 1;

BEGIN;
UPDATE
    animals
SET
    owner_id = 4
WHERE
    owner_id IS NULL
RETURNING *;