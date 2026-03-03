EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.purchase
WHERE price > 25;

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.users
WHERE email = 'user50000@mail.com';

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.movie
WHERE description LIKE '%movie%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.users
WHERE name LIKE 'Admin%';

EXPLAIN (ANALYZE, BUFFERS)
SELECT v.*, m.title
FROM cinema.viewing v
         JOIN cinema.movie m ON v.movie_id = m.movie_id
WHERE m.movie_id IN (100, 1000, 5000, 10000, 25000);



