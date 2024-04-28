CREATE OR REPLACE FUNCTION fn_creator_with_board_games(target_first_name VARCHAR(30))
    RETURNS INT AS
$$
DECLARE
    total_games INT;
BEGIN
    SELECT count(board_game_id)
    INTO total_games
    FROM creators
             JOIN creators_board_games on creators.id = creators_board_games.creator_id
    WHERE first_name = target_first_name;

    RETURN total_games;
END;
$$ LANGUAGE plpgsql;

SELECT fn_creator_with_board_games('Bruno');


SELECT count(board_game_id)
FROM creators
         JOIN creators_board_games on creators.id = creators_board_games.creator_id
WHERE first_name = 'Bruno';