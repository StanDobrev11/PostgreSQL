UPDATE products
SET price = price * 1.1
WHERE id IN (SELECT products.id as id
            FROM products
                     JOIN feedbacks ON products.id = feedbacks.product_id
            WHERE feedbacks.rate > 8)
;

SELECT products.id as id
FROM products
         JOIN feedbacks ON products.id = feedbacks.product_id
WHERE feedbacks.rate > 8
;