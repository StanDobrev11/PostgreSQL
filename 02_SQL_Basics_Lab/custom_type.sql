-- creating custom type data with multiple data

CREATE TYPE address AS (
    street VARCHAR(30),
    number INTEGER,
    city VARCHAR(30),
    country VARCHAR(30),
    postal_code CHAR(4)
);

-- create table and set type of the column as the custom type

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(30),
    customer_address address
);

-- input data in that table

INSERT INTO
    customers (customer_name, customer_address)
VALUES ('Ivan', ('some street', 5, 'Varna', 'BG', '9021'));
