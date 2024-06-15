SELECT
    ingredients.name as ingredient_name,
    products.name as product_name,
    distributors.name as distributor_name
FROM
    ingredients
JOIN products_ingredients ON ingredients.id = products_ingredients.ingredient_id
JOIN products ON products_ingredients.product_id = products.id
JOIN distributors ON ingredients.distributor_id = distributors.id
WHERE
    ingredients.name ILIKE 'mustard'
AND
    distributors.country_id = 16
ORDER BY
    product_name;


