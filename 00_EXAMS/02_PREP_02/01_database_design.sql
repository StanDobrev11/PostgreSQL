CREATE TABLE IF NOT EXISTS addresses(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS clients(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS drivers(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL CHECK (age > 0),
    rating NUMERIC(2, 1) DEFAULT 5.5
);

CREATE TABLE IF NOT EXISTS cars(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 0 CHECK (year > 0),
    mileage INT DEFAULT 0 CHECK (mileage > 0),
    condition CHAR(1) NOT NULL,
    category_id INT NOT NULL,

    CONSTRAINT fk_cars_categories
        FOREIGN KEY (category_id)
            REFERENCES categories(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS courses(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    from_address_id INT NOT NULL,
    start TIMESTAMP NOT NULL,
    bill NUMERIC(10, 2) DEFAULT 10 CHECK (bill > 0),
    car_id INT NOT NULL,
    client_id INT NOT NULL,

    CONSTRAINT fk_courses_addresses
        FOREIGN KEY (from_address_id)
            REFERENCES addresses(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT fk_courses_cars
        FOREIGN KEY (car_id)
            REFERENCES cars(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT fk_courses_clients
        FOREIGN KEY (client_id)
            REFERENCES clients(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cars_drivers(
    car_id INT NOT NULL,
    driver_id INT NOT NULL,

    CONSTRAINT fk_cars_drivers_cars
        FOREIGN KEY (car_id)
            REFERENCES cars(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    CONSTRAINT fk_cars_drivers_drivers
        FOREIGN KEY (driver_id)
            REFERENCES drivers(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

