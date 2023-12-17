SELECT
    p.id,
    concat(first_name, ' ', last_name) AS full_name,
    age,
    position,
    salary,
    pace,
    shooting
FROM
    players AS p
        JOIN
            skills_data AS sd ON sd.id = p.skills_data_id
WHERE
    team_id IS NULL
        AND
    pace + shooting > 130
        AND
    position = 'A';