SELECT
    product_name,
    round(average_price, 2),
    total_feedbacks
FROM (
    SELECT
        products.name AS product_name,
        AVG(products.price) AS average_price,
        COUNT(feedbacks.id) AS total_feedbacks
    FROM
        products
        JOIN feedbacks ON products.id = feedbacks.product_id
    WHERE
        products.price > 15
    GROUP BY
        products.name
) AS subquery
WHERE
    total_feedbacks > 1
ORDER BY
    total_feedbacks,
    average_price DESC;
