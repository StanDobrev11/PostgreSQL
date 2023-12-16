-- 1. User-defined Function Full Name

CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
    BEGIN;
        RETURN trim(initcap(concat(first_name, ' ', last_name)));
    END;
$$ LANGUAGE plpgsql;

SELECT
    fn_full_name('ivan', 'asen');

SELECT
    fn_full_name(null, 'asen');

SELECT
    fn_full_name('ivan', null);

SELECT
    fn_full_name(null, null);

SELECT
    initcap('ivan');
-----------------------------------------------------------------
-- 2. User-defined Function Future Value
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
    initial_sum DECIMAL,
    yearly_interest_rate DECIMAL,
    number_of_years INT
    )
RETURNS DECIMAL AS
$$
    DECLARE
        result DECIMAL;
    BEGIN
--        result := POWER(1 + yearly_interest_rate, number_of_years) * initial_sum
        result := ((1 + yearly_interest_rate) ^ number_of_years) * initial_sum;
        result := trunc(result, 4);
        RETURN result;
    END
$$ LANGUAGE plpgsql;

SELECT
    fn_calculate_future_value (1000, 0.1, 5);

SELECT
    ROUND(1.660302, 4);

--03. User-defined Function Is Word Comprised
-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BOOLEAN AS $$
DECLARE
    result VARCHAR;
BEGIN
    word := LOWER(word);
    set_of_letters := LOWER(set_of_letters);

    result := TRIM(word, set_of_letters);

    IF result = '' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BOOLEAN AS $$
BEGIN
    RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
END
$$ LANGUAGE plpgsql;


SELECT
    fn_is_word_comprised('ois tmiah%f', 'halves');
SELECT
    fn_is_word_comprised('ois tmiah%f', 'Sofia');
SELECT
    fn_is_word_comprised('bobr', 'Rob');
SELECT
    fn_is_word_comprised('b', 'b');
SELECT
    TRIM ('rob', 'bobr') = '';

-- 04. Game Over
-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE (name VARCHAR(50), game_type_id INT, is_finished BOOLEAN)
AS $$
BEGIN
    RETURN QUERY (
        SELECT
            games.name,
            games.game_type_id,
            games.is_finished
        FROM
            games
        WHERE
            games.is_finished = is_game_over
        );
END
$$ LANGUAGE plpgsql;

SELECT (fn_is_game_over(true)).*;
-----------------------------------------------------------------
-- 05. Difficulty Level
CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR AS $$
BEGIN
    IF level <= 40 THEN RETURN 'Normal Difficulty';
    ELSIF level <= 60 THEN RETURN 'Nightmare Difficulty';
    ELSE
        RETURN 'Hell Difficulty';
    END IF;
END
$$ LANGUAGE plpgsql;

SELECT
    fn_difficulty_level(41);

SELECT
    user_id,
    level,
    cash,
    fn_difficulty_level(level) AS difficulty_level
FROM
    users_games
ORDER BY
    user_id;
-----------------------------------------------------------------
--6. * Cash in User Games Odd Rows
CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
RETURNS TABLE (total_cash NUMERIC) AS $$
BEGIN
    RETURN QUERY (
        SELECT
            round(sum(cash), 2)
        FROM (
            SELECT
                ROW_NUMBER() OVER (ORDER BY cash DESC) AS row_num,
                *
            FROM
                users_games
                    JOIN games ON game_id = games.id
            WHERE
                name = game_name
            ) AS subquery
        WHERE
            row_num % 2 = 1);
END
$$ LANGUAGE plpgsql;

SELECT
    fn_cash_in_users_games('Delphinium Pacific Giant');

SELECT
    fn_cash_in_users_games('Love in a mist');
-----------------------------------------------------------------
--7. Retrieving Account Holders
CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(searched_balance NUMERIC)
AS $$
DECLARE
    i INT;
    max_iters INT;
    f_name VARCHAR;
    s_balance DECIMAL;
BEGIN
    -- get max iters
    max_iters := (SELECT max(account_holder_id) FROM  accounts);
    -- loop through each account holder
    FOR i IN 1..max_iters LOOP
        -- extract temporary table to facilitate sub queries
        WITH total_balance AS (SELECT
            concat(first_name, ' ', last_name) AS full_name,
            sum(balance) AS sum_balance
        FROM
            accounts
            JOIN
                account_holders ON account_holders.id = account_holder_id
        WHERE
            account_holder_id = i
        GROUP BY
            full_name)
        -- save the table values into vars in order to use same in raise notice
        SELECT
            full_name,
            sum_balance
        INTO
            f_name,
            s_balance
        FROM
            total_balance;
        -- check if balance is matching the condition stipulated
        IF s_balance > searched_balance THEN
            RAISE NOTICE '% - %', f_name, s_balance;
        END IF;

    END LOOP;
END
$$ LANGUAGE plpgsql;

--- DIDO KALAYDJIEV SOLUTION
CREATE OR REPLACE PROCEDURE
    sp_retrieving_holders_with_balance_higher_than(searched_balance NUMERIC)
AS $$
DECLARE
    holder_info RECORD;
BEGIN
    FOR holder_info IN
        SELECT
            concat(first_name, ' ', last_name) AS full_name,
            sum(balance) AS total_balance
        FROM
            account_holders
            JOIN
                accounts ON account_holder_id = account_holders.id
        GROUP BY
            full_name
        HAVING
            sum(balance) > searched_balance
        ORDER BY
            full_name
    LOOP
        RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
    END LOOP;
END
$$ LANGUAGE plpgsql;



CALL
    sp_retrieving_holders_with_balance_higher_than(200000);


SELECT
    *
FROM
    accounts
    JOIN
        account_holders ON account_holders.id = account_holder_id
ORDER BY
    account_holder_id
;



SELECT
    account_holder_id,
    concat(first_name, ' ', last_name) AS full_name,
    sum(balance) AS "Total Balance"
FROM
    accounts
    JOIN
        account_holders ON account_holders.id = account_holder_id
GROUP BY
    account_holder_id,
    account_holders.id,
    full_name
HAVING
   sum(balance) >= 200000
ORDER BY
    account_holders.id;

-----------------------------------------------------------------
--8. Deposit Money

CREATE OR REPLACE PROCEDURE
    sp_deposit_money(account_id INT, money_amount DECIMAL(10,4))
AS $$
BEGIN
    UPDATE
        accounts
    SET
        balance = balance + money_amount
    WHERE
        id = account_id;
--    COMMIT;
END
$$
LANGUAGE plpgsql;

CALL
    sp_deposit_money(1, 200);
SELECT
    balance
FROM
    accounts
WHERE
    id = 1;

------------------------------------------------------------------------
--9. Withdraw Money
CREATE OR REPLACE PROCEDURE
    sp_withdraw_money(account_id INT, money_amount DECIMAL(10,4))
AS $$
BEGIN
--    IF (SELECT balance FROM accounts WHERE account_id = id) < money_amount THEN
--        RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
--        ROLLBACK;
--        RETURN;
--    END IF;

    UPDATE
        accounts
    SET
        balance = balance - money_amount
    WHERE
        account_id = id;

--    IF (SELECT balance FROM accounts WHERE account_id = id) < 0 THEN
--        RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
--        ROLLBACK;
--
--    COMMIT;
END
$$ LANGUAGE plpgsql;

CALL
    sp_withdraw_money(3, 5050.7500);
SELECT
    balance
FROM
    accounts
WHERE
    id = 3;

CALL
    sp_withdraw_money(6, 5437.0000);
SELECT
    balance
FROM
    accounts
WHERE
    id = 6;
------------------------------------------------------------------
--10. Money Transfer
CREATE OR REPLACE PROCEDURE
    sp_transfer_money(sender_id INT, receiver_id INT, amount NUMERIC(10,4))
AS $$
DECLARE
    sender_current_balance DECIMAL;
BEGIN
    CALL sp_withdraw_money(sender_id, amount);
    CALL sp_deposit_money(receiver_id, amount);

    SELECT balance INTO sender_current_balance FROM accounts WHERE id = sender_id;

    IF sender_current_balance < 0 THEN
        RAISE NOTICE 'Insufficient balance to withdraw %', amount;
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;

END
$$ LANGUAGE plpgsql;

CALL
    sp_transfer_money(1, 5, 15000);

SELECT * FROM accounts ORDER BY id;
--CREATE OR REPLACE PROCEDURE
--    sp_transfer_money(sender_id INT, receiver_id INT, amount NUMERIC(10,4))
--AS $$
--DECLARE
--    sender_account INT;
--    receiver_account INT;
--BEGIN
--    -- get valid sender account number with sufficient amount to withdraw
--    sender_account := fn_get_valid_sender_account(sender_id, amount);
--    -- check if null and rollback else withdraw money
--    IF sender_account IS NULL THEN
--        ROLLBACK;
--        RETURN;
--    ELSE CALL sp_withdraw_money(sender_account, amount);
--    END IF;
--    -- get valid receivers account number
--    receiver_account := fn_get_valid_receiver_account(receiver_id);
--
--    IF receiver_account IS NULL THEN
--        ROLLBACK;
--        RETURN;
--    ELSE CALL sp_deposit_money(receiver_account, amount);
--    END IF;
--END
--$$ LANGUAGE plpgsql;
--
--CREATE OR REPLACE FUNCTION
--    fn_get_valid_sender_account(IN sender_id INT, IN amount INT, OUT account_id INT)
--AS $$
--BEGIN
--    account_id :=
--        (SELECT
--            id
--        FROM
--            accounts
--        WHERE
--            account_holder_id = sender_id
--                AND
--            balance >= amount
--        LIMIT 1);
--END
--$$ LANGUAGE plpgsql;
----
----SELECT
----    fn_get_valid_sender_account(1, 1000000000)
--CREATE OR REPLACE FUNCTION
--    fn_get_valid_receiver_account(IN receiver_id INT, OUT account_id INT)
--AS $$
--BEGIN
--    account_id :=
--        (SELECT
--            id
--        FROM
--            accounts
--        WHERE
--            account_holder_id = receiver_id
--        LIMIT 1);
--END
--$$ LANGUAGE plpgsql;
--
--SELECT
--    *
--FROM
--    accounts
--WHERE
--    account_holder_id IN (1,5)

-------------------------------------------------------------------
--12. Log Accounts Trigger
CREATE TABLE IF NOT EXISTS logs(
     id SERIAL PRIMARY KEY,
     account_id INT,
     old_sum DECIMAL,
     new_sum DECIMAL
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS $$
BEGIN
--    IF OLD.balance <> NEW.balance THEN
        INSERT INTO
            logs(account_id, old_sum, new_sum)
        VALUES
            (OLD.id, OLD.balance, NEW.balance);
--    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_account_balance_change
--AFTER UPDATE ON accounts
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN
    (NEW.balance <> OLD.balance)
EXECUTE FUNCTION
    trigger_fn_insert_new_entry_into_logs();

UPDATE accounts SET balance = 100 WHERE id = 3;
UPDATE accounts SET balance = 5323.12 WHERE id = 1;

SELECT * FROM accounts ORDER BY id;
SELECT * FROM logs;
----------------------------------------------------------------
--13. Notification Email on Balance Change
CREATE TABLE IF NOT EXISTS notification_emails(
    id SERIAL PRIMARY KEY,
    recipient_id INT,
    subject TEXT,
    body TEXT
);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS $$
DECLARE
    subject TEXT;
    body TEXT;
BEGIN
    subject := (SELECT FORMAT('Balance change for account: %s', NEW.account_id));
    body := (SELECT FORMAT('On %s your balance was changed from %s to %s.', date(now())::text, NEW.old_sum, NEW.new_sum));

    INSERT INTO
        notification_emails(recipient_id, subject, body)
    VALUES
        (NEW.account_id, subject, body);
    RETURN new;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();

UPDATE accounts SET balance = 100 WHERE id = 1;
UPDATE accounts SET balance = 5323.12 WHERE id = 1;

SELECT * FROM accounts ORDER BY id;
SELECT * FROM logs;
SELECT * FROM notification_emails;

SELECT
    *
FROM
    logs
WHERE
    account_id = 1;

UPDATE
    logs
SET new_sum = new_sum + 100
WHERE
    account_id = 1;