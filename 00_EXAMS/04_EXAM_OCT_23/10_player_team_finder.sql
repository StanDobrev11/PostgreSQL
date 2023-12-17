CREATE OR REPLACE PROCEDURE sp_players_team_name(
    IN player_name VARCHAR(50),
    OUT team_name VARCHAR(45))
AS $$
BEGIN
    team_name :=
        (SELECT
            teams.name
        FROM
            players
            JOIN
                teams ON team_id = teams.id
        WHERE
            POSITION(first_name IN player_name) > 0
                AND
            POSITION(last_name IN player_name) > 0
        );

    IF team_name IS NULL THEN
        team_name := 'The player currently has no team';
    END IF;

END
$$ LANGUAGE plpgsql;

CALL sp_players_team_name('Walther Olenchenko', '');
CALL sp_players_team_name('Isaak Duncombe', '');