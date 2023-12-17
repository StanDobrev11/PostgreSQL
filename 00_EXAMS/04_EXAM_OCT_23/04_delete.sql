BEGIN;

DELETE FROM
    players AS p
WHERE
    hire_date < '2013-12-13 07:18:46';
