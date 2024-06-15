INSERT INTO addresses (street, town, country, account_id)

SELECT
    username as street,
    password as town,
    ip as country,
    age as account_id
FROM
    accounts
WHERE
    gender LIKE 'F'
;