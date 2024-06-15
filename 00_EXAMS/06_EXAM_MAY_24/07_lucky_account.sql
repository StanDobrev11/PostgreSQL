SELECT
    CONCAT(accounts.id, ' ', accounts.username) as id_username,
    email
FROM accounts
JOIN accounts_photos ON accounts.id = accounts_photos.account_id
WHERE account_id = photo_id
ORDER BY
    account_id ;