SELECT
    v.name AS volunteers,
    v.phone_number,
    TRIM('Sofia, ' FROM v.address)
FROM
    volunteers AS v
    JOIN
        volunteers_departments AS vd ON v.department_id = vd.id
WHERE
    vd.department_name LIKE 'Education program assistant'
        AND
    v.address LIKE '%Sofia%'
ORDER BY
    v.name ASC;