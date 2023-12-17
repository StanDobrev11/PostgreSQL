SELECT
    t.id AS team_id,
    t.name AS team_name,
    count(p.id) AS player_count,
    t.fan_base AS fan_base
FROM
    teams AS t
    LEFT JOIN
        players AS p ON p.team_id = t.id
WHERE
    fan_base > 30000
GROUP BY
    t.id
ORDER BY
    player_count DESC,
    fan_base DESC
;