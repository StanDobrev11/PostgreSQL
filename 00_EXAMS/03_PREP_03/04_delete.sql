-- otherwise it will violate foreign key constraint

DELETE FROM
    board_games
WHERE publisher_id IN
(SELECT id
 FROM publishers
 WHERE address_id IN
       (SELECT id
        FROM addresses
        WHERE substring(town, 1, 1) = 'L'))
;


DELETE FROM publishers
WHERE address_id IN
      (SELECT id
       FROM addresses
       WHERE substring(town, 1, 1) = 'L')
;


DELETE FROM addresses
WHERE substring(town, 1, 1) = 'L'
;