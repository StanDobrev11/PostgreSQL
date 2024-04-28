SELECT
    creators.id,
    concat(creators.first_name, ' ', creators.last_name) as creator_name,
    creators.email
FROM
    creators
LEFT JOIN creators_board_games ON creators.id = creators_board_games.creator_id
GROUP BY
    creators.id
HAVING
    count(board_game_id) = 0
ORDER BY
    creator_name
;