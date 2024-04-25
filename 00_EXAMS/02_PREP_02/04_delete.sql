BEGIN;

DELETE FROM clients
WHERE
    clients.id NOT IN (SELECT client_id FROM courses)
    AND
    length(clients.full_name) > 3
RETURNING *
;

SELECT
    *
FROM
    clients
WHERE
    clients.id NOT IN (SELECT client_id FROM courses)
    AND
    length(clients.full_name) > 3
;