CREATE VIEW
    view_autor_book AS
SELECT
    concat_ws(', ',authors.last_name, authors.first_name) AS "Full Name",
    books.title
FROM
    authors
JOIN
    books
ON
    authors.id = books.author_id;
----------------------------------
CREATE VIEW
    view_trunc_desc AS
SELECT
    title AS "Book Title",
    LEFT(description, 100) AS "Truncated Description"
FROM
    books
ORDER BY
    author_id;
-------------------------------------------------------
-- 01 Find Book Titles
SELECT
    title
FROM
    books
WHERE
    title LIKE 'The%'
ORDER BY
    id;
-------------------------------------------------------
-- 02 Replace Titles
SELECT
--    concat_ws(' ', '***', SUBSTRING(title, 5))
--    SUBSTRING(string, FROM 'start_idx' FOR 'how_many_idcs')
    replace(title, 'The', '***')
FROM
    books
WHERE
    title LIKE 'The%'
ORDER BY
    id;
-------------------------------------------------------
-- 03 Triangles on Bookshelves
SELECT
    id,
    (side * height) / 2 AS area
FROM
    triangles
ORDER BY
    id;
-------------------------------------------------------
-- 04 Format Costs
SELECT
    title,
    round(cost, 3) AS modified_price
FROM
    books;
-------------------------------------------------------
-- 05 Year of Birth
SELECT
    first_name,
    last_name,
    extract('year' from born) AS "year"
FROM
    authors;
-------------------------------------------------------
-- 06 Format Date of Birth
SELECT
    last_name,
    to_char(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM
    authors;
-------------------------------------------------------
-- 07 Harry Potter Books
SELECT
    title
FROM
    books
WHERE
    title LIKE '%Harry Potter%';













