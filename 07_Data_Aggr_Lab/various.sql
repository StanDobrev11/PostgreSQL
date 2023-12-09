----------------------------------------
-- selects the first value of many which is not null
-- if null will return next one, used as filter
-- the parameters pass ALWAYS to be of the same TYPE

SELECT
    coalesce(1, 2, 3)

