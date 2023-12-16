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