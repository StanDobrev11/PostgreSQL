-- DOUBLE QUOTES "" ARE USED WHEN NAMING SPECIAL WORDS OR CAPS WORDS


-- create table
CREATE TABLE person (
    f_name VARCHAR(30),
    l_name VARCHAR(30),
);

-- create custom sequence
CREATE SEQUENCE person_id_by_2_seq
START 4
INCREMENT 2
OWNED BY person.id ; -- this is the column owning the seq. If the col is deleted, seq is gone.

-- attached to table
ALTER TABLE person
ALTER COLUMN id SET DEFAULT nextval('person_id_by_2_seq');

-- insert
INSERT INTO person (f_name, l_name)
VALUES
    ('IVAN', 'ANGELOV'),
    ('Kolio', 'Kolev'),
    ('Sway', 'Dobrev');

-- dropping primary key
ALTER TABLE person
DROP CONSTRAINT person_pkey

-- adding primary key
ALTER TABLE person
ADD CONSTRAINT person_pkey PRIMARY KEY (id)

