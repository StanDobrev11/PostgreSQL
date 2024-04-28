SELECT
    concat(creators.first_name, ' ', creators.last_name) as full_name,
    email,
    max(bg.rating) as rating
FROM
    creators
JOIN
    creators_board_games ON creators.id = creators_board_games.creator_id
JOIN
    board_games as bg ON creators_board_games.board_game_id = bg.id
GROUP BY
    full_name,
    email
ORDER BY
    full_name
LIMIT
    3
;