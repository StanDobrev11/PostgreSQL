DROP TABLE IF EXISTS search_results;
CREATE TABLE search_results
(
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(50),
    release_year   INT,
    rating         FLOAT,
    category_name  VARCHAR(50),
    publisher_name VARCHAR(50),
    min_players    VARCHAR(50),
    max_players    VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE usp_search_by_category(cat_name VARCHAR(30))
AS
$$
BEGIN
    TRUNCATE TABLE search_results;
    INSERT INTO search_results(name,
                               release_year,
                               rating,
                               category_name,
                               publisher_name,
                               min_players,
                               max_players)
    SELECT bg.name,
           bg.release_year,
           bg.rating,
           c.name,
           p.name,
           concat(CAST(pr.min_players as VARCHAR), ' people'),
           concat(CAST(pr.max_players as VARCHAR), ' people')
    FROM board_games AS bg
             JOIN categories AS c ON bg.category_id = c.id
             JOIN publishers AS p ON bg.publisher_id = p.id
             JOIN players_ranges AS pr ON bg.players_range_id = pr.id
    WHERE c.name = cat_name
    ORDER BY p.name,
             bg.release_year DESC;

end;
$$ LANGUAGE plpgsql;



CALL usp_search_by_category('Wargames');

SELECT *
FROM search_results;
