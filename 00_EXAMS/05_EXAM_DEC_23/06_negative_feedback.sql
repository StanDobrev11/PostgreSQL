SELECT
    product_id,
    feedbacks.rate as rate,
    feedbacks.description as description,
    customer_id,
    customers.age as age,
    customers.gender as gender
FROM
    feedbacks
JOIN customers ON feedbacks.customer_id = customers.id
WHERE
    feedbacks.rate < 5
        AND
    customers.gender = 'F'
        AND
    customers.age > 30
ORDER BY
    product_id DESC
;
