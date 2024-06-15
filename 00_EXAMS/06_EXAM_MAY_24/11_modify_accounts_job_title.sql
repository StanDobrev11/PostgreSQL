CREATE OR REPLACE PROCEDURE udp_modify_account(
    IN address_street VARCHAR(50),
    IN address_town VARCHAR(30))
AS
$$
BEGIN
    UPDATE accounts
    SET job_title = CONCAT('(Remote)', ' ', job_title)
    WHERE accounts.id =
          (SELECT account_id
           FROM addresses
                    JOIN accounts ON addresses.account_id = accounts.id
           WHERE street = address_street
             AND town = address_town)
      AND NOT job_title LIKE '(Remote) %';
END
$$ LANGUAGE plpgsql;

CALL udp_modify_account('97 Valley Edge Parkway', 'Divinópolis');
SELECT a.username, a.gender, a.job_title
FROM accounts AS a
WHERE a.job_title ILIKE '(Remote)%';

CALL udp_modify_account('97 Valley Edge Parkway', 'Nonexistent');
SELECT a.username, a.gender, a.job_title
FROM accounts AS a
WHERE a.job_title ILIKE '(Remote)%';

