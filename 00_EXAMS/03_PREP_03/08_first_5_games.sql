SELECT
    bg.name,
    bg.rating,
    c.name
FROM
    board_games as bg
JOIN
    categories as c ON bg.category_id = c.id
JOIN
    players_ranges as pr ON bg.players_range_id = pr.id
WHERE
    bg.rating > 7
    AND
    (bg.name ILIKE '%a%' OR bg.rating > 7.5)
    AND
    (pr.min_players >=2 AND pr.max_players <=5)
ORDER BY
    bg.name,
    bg.rating DESC
LIMIT
    5
;