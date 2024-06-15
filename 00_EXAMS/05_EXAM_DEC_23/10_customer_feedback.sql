CREATE OR REPLACE FUNCTION fn_feedbacks_for_product(
    product_name VARCHAR(25)
)
    RETURNS TABLE
            (
                customer_id INT,
                customer_name VARCHAR(75),
                feedback_description VARCHAR(255),
                feedback_rate NUMERIC(4,2)
            )
AS
$$
BEGIN
    RETURN QUERY
    SELECT
        customers.id as customer_id,
        customers.first_name as customer_name,
        feedbacks.description as feedback_description,
        feedbacks.rate as feedback_rate
    FROM customers
    JOIN feedbacks ON customers.id = feedbacks.customer_id
    JOIN products ON feedbacks.product_id = products.id
    WHERE
        products.name = product_name
    ORDER BY
        customer_id;

END
$$ LANGUAGE plpgsql;


SELECT * FROM fn_feedbacks_for_product('Banitsa');
