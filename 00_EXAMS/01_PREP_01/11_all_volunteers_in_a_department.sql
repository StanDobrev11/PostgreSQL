CREATE OR REPLACE FUNCTION
    fn_get_volunteers_count_from_department(
        IN searched_volunteers_department VARCHAR(30),
        OUT count_of_volunteers INT)
AS $$
BEGIN
    count_of_volunteers := (
        SELECT
            count(*)
        FROM
            volunteers AS v
            JOIN
                volunteers_departments AS vd ON vd.id = v.department_id
--        WHERE
--            department_name = searched_volunteers_department
        GROUP BY
            department_name
        HAVING
            department_name = searched_volunteers_department
        );
END
$$ LANGUAGE plpgsql;

SELECT
    fn_get_volunteers_count_from_department('Animal encounters');

SELECT * FROM volunteers WHERE department_id = 4;
