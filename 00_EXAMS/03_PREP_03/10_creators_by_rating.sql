SELECT
    cr.last_name as last_name,
    ceil(avg(bg.rating)) as average_rating,
    p.name as publisher_name
FROM
    creators as cr
JOIN creators_board_games ON cr.id = creators_board_games.creator_id
JOIN board_games as bg ON creators_board_games.board_game_id = bg.id
JOIN publishers as p ON bg.publisher_id = p.id
WHERE
    p.name LIKE 'Stonemaier Games'
GROUP BY
    cr.last_name,
    p.name
ORDER BY
    average_rating DESC
;