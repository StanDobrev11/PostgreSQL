SELECT
    distributors.name as distributor_name,
    ingredients.name as ingredient_name,
    products.name as product_name,
    AVG(feedbacks.rate) as average_rate
FROM
    distributors
JOIN ingredients ON distributors.id = ingredients.distributor_id
JOIN products_ingredients ON ingredients.id = products_ingredients.ingredient_id
JOIN products ON products_ingredients.product_id = products.id
JOIN feedbacks ON products.id = feedbacks.product_id

GROUP BY distributors.name, ingredients.name, products.name
HAVING
    AVG(feedbacks.rate) BETWEEN 5 AND 8
ORDER BY
    distributor_name,
    ingredient_name,
    product_name;