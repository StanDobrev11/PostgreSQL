CREATE TABLE owners(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50)
);

CREATE TABLE animal_types(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE cages(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    animal_type_id INT NOT NULL,

    CONSTRAINT fk_cages_animal_types
        FOREIGN KEY (animal_type_id)
            REFERENCES animal_types(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE animals(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,
    owner_id INT,
    animal_type_id INT NOT NULL,

    CONSTRAINT fk_animals_owners
        FOREIGN KEY (owner_id)
            REFERENCES owners(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_animals_animal_types
        FOREIGN KEY (animal_type_id)
            REFERENCES animal_types(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE volunteers_departments(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    department_name VARCHAR(30) NOT NULL
);

CREATE TABLE volunteers(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50),
    animal_id INT,
    department_id INT NOT NULL,

    CONSTRAINT fk_volunteers_animals
        FOREIGN KEY (animal_id)
            REFERENCES animals(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_volunteers_volunteers_departments
        FOREIGN KEY (department_id)
            REFERENCES volunteers_departments(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

CREATE TABLE animals_cages(
    cage_id INT NOT NULL,
    animal_id INT NOT NULL,

    CONSTRAINT fk_animals_cages_cages
        FOREIGN KEY (cage_id)
            REFERENCES cages(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_animals_cages_animals
        FOREIGN KEY (animal_id)
            REFERENCES animals(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);