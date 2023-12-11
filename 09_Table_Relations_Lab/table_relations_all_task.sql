--01. Mountains and Peaks
CREATE TABLE
    mountains (
        id INT PRIMARY KEY UNIQUE,
        name VARCHAR(50)
);

CREATE TABLE
    peaks (
        id INT PRIMARY KEY UNIQUE,
        name VARCHAR(50),
        mountain_id INT,

        CONSTRAINT
            fk_peaks_mountains
                FOREIGN KEY (mountain_id) REFERENCES mountains(id)
);
----------------------------------------------------------------------------
-- 02

SELECT
    v.driver_id,
    v.vehicle_type,
    concat(c.first_name, ' ', c.last_name) AS driver_name
FROM
    campers as c JOIN vehicles as v ON
        c.id = v.driver_id;
----------------------------------------------------------------------------
-- 03
SELECT
    r.start_point,
    r.end_point,
    r.leader_id,
    concat(c.first_name, ' ', c.last_name) AS leader_name
FROM
    routes AS r JOIN
        campers AS c ON
            r.leader_id = c.id;
----------------------------------------------------------------------------
-- 04
CREATE TABLE
    mountains (
        id INT PRIMARY KEY UNIQUE,
        name VARCHAR(50)
);

CREATE TABLE
    peaks (
        id INT PRIMARY KEY UNIQUE,
        name VARCHAR(50),
        mountain_id INT,

        CONSTRAINT
            fk_mountains_id
                FOREIGN KEY (mountain_id) REFERENCES mountains(id)
                ON DELETE CASCADE
);