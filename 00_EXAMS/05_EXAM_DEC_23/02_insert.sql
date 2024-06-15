CREATE TABLE IF NOT EXISTS gift_recipients
(
    id         INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name       VARCHAR(255),
    country_id INT,
    gift_sent  BOOLEAN DEFAULT FALSE

);

INSERT INTO gift_recipients (name, country_id)
SELECT
    CONCAT(customers.first_name, ' ', customers.last_name) as name,
    customers.country_id as country_id
FROM customers;

UPDATE gift_recipients
SET gift_sent = TRUE
WHERE gift_recipients.country_id IN (7, 8, 14, 17, 26)
;
