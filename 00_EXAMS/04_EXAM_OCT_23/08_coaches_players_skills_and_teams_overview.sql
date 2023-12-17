SELECT
    concat(c.first_name, ' ', c.last_name) AS coach_full_name,
    concat(p.first_name, ' ', p.last_name) AS player_full_name,
    t.name AS team_name,
    sd.passing,
    sd.shooting,
    sd.speed
FROM
    coaches AS c
    JOIN
        players_coaches AS pc ON c.id = pc.coach_id
    JOIN
        players AS p ON p.id = pc.player_id
    JOIN
        teams AS t ON t.id = team_id
    JOIN
        skills_data AS sd ON sd.id = p.skills_data_id
ORDER BY
    coach_full_name ASC,
    player_full_name DESC
;
