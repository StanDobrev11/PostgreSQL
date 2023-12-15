WRITING A FUNCTION IN POSTGREDQL
--------------------------------
-- IN THE BRACKETS SPECIFY TYPE OF PASSED ARGS
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
-- ALWAYS RETURNS
RETURNS VARCHAR AS
$$
    BEGIN
    -- BODY OF THE FUNCT. MAIN LOGIC, WHERE $ IS USED AS PLACEHOLDER
    -- OF THE ARGS
        RETURN concat($1, ' ', $2);
    END
$$
-- WRITE LANGUAGE SO THE SQL KNOWS WHICH LANGUAGE IS USED
LANGUAGE plpgsql;

-- CALL FUNCTION
SELECT
    fn_full_name('Kumcho', 'Valcho');

-- in order to use variable names, they MUST be declared
CREATE OR REPLACE FUNCTION fn_full_name_vars(VARCHAR, VARCHAR)
RETURNS VARCHAR AS
$$
    DECLARE
        first_name ALIAS FOR $1;
        last_name ALIAS FOR $2;
    BEGIN
        RETURN concat(first_name, ' ', last_name);
    END
$$
LANGUAGE plpgsql;

SELECT
    fn_full_name_vars('Mincho', 'Praznikov');

-- also can be passed names and TYPES of the parameters like and then without creating aliases:
CREATE OR REPLACE FUNCTION fn_full_name_vars_1(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
    BEGIN
        RETURN concat(first_name, ' ', last_name);
    END
$$
LANGUAGE plpgsql;

SELECT
    fn_full_name_vars_1('Mincho', 'Praznikov');

-- here we have declared new variable and we are returning it
-- WHEN HAVE IF -> END IF the syntactics is as fles:
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
    DECLARE
        full_name VARCHAR;
    BEGIN
        IF first_name IS NULL AND last_name IS NULL THEN
            full_name := NULL;

        ELSIF first_name IS NULL THEN
            full_name = last_name;

        ELSIF last_name IS NULL THEN
            full_name := first_name;

        ELSE
            full_name := concat(first_name, ' ', last_name);
        END IF;

        RETURN full_name;
    END
$$
LANGUAGE plpgsql;

SELECT
    fn_full_name('Mincho', 'Praznikov');
SELECT
    fn_full_name(null, 'Praznikov');
SELECT
    fn_full_name('Mincho', null);


-- funcs with IN-OUT parameters:
CREATE OR REPLACE FUNCTION fn_get_city_id(
    IN city_name VARCHAR,
    OUT city_id INT,
    OUT status INT --the status will return 0 on correct execution of the query
) AS -- NO RETURNS SINCE WE DECLARE INSIDE
$$
    DECLARE
        -- city_id INT; -- if is declared in the function creation - not required
        temp_id INT;
    BEGIN
        SELECT town_id FROM towns WHERE name = city_name
        INTO temp_id;

        IF temp_id IS NULL THEN
            SELECT 100 INTO status; -- USING SELECT since it is not declared in the body
        ELSE
            city_id := temp_id;
            status := 0;
--            SELECT temp_id, 0 INTO city_id, status;

        END IF;
    END
$$
LANGUAGE plpgsql;

SELECT
    fn_get_city_id('Sofia');
SELECT
    (fn_get_city_id('Sofia')).*; -- THIS WILL GET THE COLUMNS DECOMPOSED
--01
CREATE OR REPLACE FUNCTION fn_get_town_id(town_name VARCHAR)
RETURNS INT AS
$$
    BEGIN
        RETURN
            (SELECT
                town_id
            FROM
                towns
            WHERE
                name = town_name);
    END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT AS
$$
    BEGIN
        RETURN (
            SELECT
                count(*)
            FROM
                employees
                    JOIN addresses USING (address_id)
                            JOIN towns USING (town_id)
            WHERE
                town_id = fn_get_town_id(town_name)
        );
    END
$$
LANGUAGE plpgsql;


SELECT
    fn_count_employees_by_town('Bellevue');

SELECT
    fn_get_town_id('Sofia');

SELECT
    address_id,
    address_text
FROM
    employees
        JOIN addresses USING (address_id)
                JOIN towns USING (town_id)
WHERE
    towns.town_id = 32;

-- 02 STORE PROCEDURES
--EXAMPLE
CREATE OR REPLACE PROCEDURE sp_increase_salaries(department_name VARCHAR) AS
$$
    BEGIN
        UPDATE
            employees
        SET
            salary = salary + salary * 0.05
        WHERE
            department_id =
            (
                SELECT
                    department_id
                FROM
                    departments
                WHERE
                    name = department_name
            );
    END
$$
LANGUAGE plpgsql;

CALL
    sp_increase_salaries('Finance');

SELECT
    first_name,
    salary
FROM
    employees
WHERE
    department_id = 10
ORDER BY
    first_name,
    salary;

-- 03
--TRANSACTIONS
CREATE TABLE
    bank (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    balance INTEGER
    );

INSERT INTO
    bank (name, balance)
VALUES
    ('Ivan', 200),
    ('Stoyan', 500),
    ('Drago', 1000);


CREATE OR REPLACE PROCEDURE p_bank_transaction(
    IN sender VARCHAR,
    IN receiver VARCHAR,
    IN transfer_amount FLOAT,
    OUT status VARCHAR)
AS
$$
    DECLARE
        sender_initial_amount FLOAT;
        receiver_initial_amount FLOAT;
        sender_final_amount FLOAT;
        receiver_final_amount FLOAT;

    BEGIN
        sender_initial_amount := (SELECT balance FROM bank WHERE name = sender);
        receiver_initial_amount := (SELECT balance FROM bank WHERE name = receiver);

        -- check for sufficient amount in senders account
        IF sender_initial_amount < transfer_amount THEN
            status := 'NOT ENOUGH BALANCE';
            RETURN;
        END IF;

        -- have enough balance, then update both accounts to reflect the transaction
        -- update sender account
        UPDATE bank SET balance = balance - transfer_amount WHERE name = sender;
        -- update receiver account
        UPDATE bank SET balance = balance + transfer_amount WHERE name = receiver;

        -- check for proper transaction
        sender_final_amount := (SELECT balance FROM bank WHERE name = sender);
        receiver_final_amount := (SELECT balance FROM bank WHERE name = receiver);

        IF sender_initial_amount - sender_final_amount <> transfer_amount THEN
            status := 'ERROR IN SENDER'
            ROLLBACK;
            RETURN;
        ELSIF receiver_final_amount - receiver_initial_amount <> transfer_amount THEN
            status := 'ERROR IN RECEIVER'
            ROLLBACK;
            RETURN;
        END IF;

        -- if all is OK commit the transaction
        status := 'TRANSACTION SUCCESSFUL'
        COMMIT;
        RETURN;
    END;
$$
LANGUAGE plpgsql;

SELECT * FROM bank;

CALL
    p_bank_transaction('Drago', 'Ivan', 1000, null);


CREATE OR REPLACE PROCEDURE sp_increase_salary_by_id(id INT) AS
$$
    BEGIN
        -- check if employee ID exist
        IF id NOT IN (SELECT employee_id FROM employees) THEN
            ROLLBACK;
            RETURN;
        END IF;

        UPDATE employees SET salary = salary * 1.05 WHERE employee_id = id;
        COMMIT;
        RETURN;
    END
$$
LANGUAGE plpgsql;

CALL sp_increase_salary_by_id(17);

SELECT
    employee_id,
    salary
FROM
    employees
WHERE
    employee_id = 17;

-------------------------------
--triggers

CREATE TABLE IF NOT EXISTS items(
    id SERIAL PRIMARY KEY,
    status INT,
    create_date DATE
);

CREATE TABLE IF NOT EXISTS items_logs(
    id SERIAL PRIMARY KEY,
    status INT,
    create_date DATE
);


INSERT INTO
    items (status, create_date)
VALUES
    (1, NOW()),
    (3, NOW()),
    (55, NOW()),
    (2, NOW());


-- IT IS CALLED WHEN THE MAIN TABLE IS ALTERED
-- and the trigger is executed with altering of main table
CREATE OR REPLACE FUNCTION log_items()
RETURNS TRIGGER AS
$$
    BEGIN
        INSERT INTO items_logs(status, create_date)
        VALUES (new.status, new.create_date);
        RETURN new;
    END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER log_items_trigger
AFTER INSERT ON items
FOR EACH ROW
EXECUTE PROCEDURE log_items();

-- TRIGGER THAT KEEPS LEN ON THE LOGS AT CERTAIN COUNT
CREATE OR REPLACE FUNCTION trg_fn_del_log()
RETURNS TRIGGER AS
$$
    BEGIN
        WHILE (SELECT count(*) FROM items_logs) > 10 LOOP
            DELETE FROM items_logs WHERE id = (SELECT min(id) FROM items_logs);
        END LOOP;
        RETURN new;
    END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER del_items_trg
AFTER INSERT ON items_logs
FOR EACH STATEMENT
EXECUTE PROCEDURE trg_fn_del_log();

-------------------TASK 4
CREATE TABLE deleted_employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20),
    job_title VARCHAR(50),
    department_id INT,
    salary NUMERIC(19,4));

CREATE OR REPLACE FUNCTION trg_delete_employee_log()
RETURNS TRIGGER AS
$$
    BEGIN
       INSERT INTO deleted_employees(
            employee_id,
            first_name,
            last_name,
            middle_name,
            job_title,
            department_id,
            salary
            )
       VALUES (
            old.employee_id,
            old.first_name,
            old.last_name,
            old.middle_name,
            old.job_title,
            old.department_id,
            old.salary
            );
       RETURN old;
    END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_del_emp
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE trg_delete_employee_log();
