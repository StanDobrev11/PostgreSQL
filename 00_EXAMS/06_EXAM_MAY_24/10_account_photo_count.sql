CREATE OR REPLACE FUNCTION udf_accounts_photos_count(
    account_username VARCHAR(30))
    RETURNS INT AS
$$
DECLARE
    photos_count INT;
BEGIN
    SELECT
        count(accounts_photos)
    INTO photos_count
    FROM
        accounts
        JOIN accounts_photos ON accounts.id = accounts_photos.account_id
    WHERE username = account_username;

    RETURN photos_count;
END;
$$ LANGUAGE plpgsql;

SELECT udf_accounts_photos_count('ssantryd') AS photos_count;
