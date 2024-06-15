SELECT
    photos.id as photo_id,
    COUNT(DISTINCT likes.id) as likes_count,
    COUNT(DISTINCT comments.id) as comments_count
FROM
    photos
LEFT JOIN likes ON photos.id = likes.photo_id
LEFT JOIN comments ON photos.id = comments.photo_id
GROUP BY photos.id
ORDER BY
    likes_count DESC,
    comments_count DESC,
    photo_id;