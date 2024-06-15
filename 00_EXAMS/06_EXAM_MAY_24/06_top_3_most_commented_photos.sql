SELECT
    photo_id,
    capture_date,
    description,
    COUNT(comments) as comments_count
FROM
    photos
JOIN comments ON photos.id = comments.photo_id
WHERE
    description IS NOT NULL
GROUP BY
    photo_id,
    capture_date,
    description
ORDER BY
    comments_count DESC,
    photo_id
LIMIT 3;