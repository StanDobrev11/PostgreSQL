CREATE TABLE IF NOT EXISTS countries
(
    id   INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS customers
(
    id         INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name   VARCHAR(25) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    gender       CHAR(1)     NULL CHECK (gender in ('M', 'F')),
    age          INT         NOT NULL CHECK (age > 0),
    phone_number CHAR(10) NOT NULL,
    country_id INT NOT NULL,
--
    CONSTRAINT fk_customers_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS products
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(25)                     NOT NULL,
    description VARCHAR(250)                    NULL,
    recipe      TEXT                            NULL,
    price       NUMERIC(10, 2) CHECK (price > 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS feedbacks
(
    id          INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    description VARCHAR(255)                                   NULL,
    rate        NUMERIC(4, 2) CHECK (rate >= 0 AND rate <= 10) NULL,
    product_id  INT                                            NOT NULL,
    customer_id INT                                            NOT NULL,

    CONSTRAINT fk_feedbacks_products
        FOREIGN KEY (product_id)
            REFERENCES products (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,

    CONSTRAINT fk_feedbacks_customers
        FOREIGN KEY (customer_id)
            REFERENCES customers (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS distributors
(
    id         INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name       VARCHAR(25) UNIQUE NOT NULL,
    address    VARCHAR(30)        NOT NULL,
    summary    VARCHAR(200)       NOT NULL,
    country_id INT                NOT NULL,
--
    CONSTRAINT fk_distributors_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ingredients
(
    id             INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name           VARCHAR(30)  NOT NULL,
    description    VARCHAR(200) NULL,
    country_id     INT          NOT NULL,
    distributor_id INT          NOT NULL,

    CONSTRAINT fk_ingredients_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_ingredients_distributors
        FOREIGN KEY (distributor_id)
            REFERENCES distributors (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS products_ingredients
(
    product_id    INT NULL,
    ingredient_id INT NULL,

    CONSTRAINT fk_products_ingredients_products
        FOREIGN KEY (product_id)
            REFERENCES products (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,

    CONSTRAINT fk_products_ingredients_ingredients
        FOREIGN KEY (ingredient_id)
            REFERENCES ingredients (id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


