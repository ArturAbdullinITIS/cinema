**-- GIN --**

1)EXPLAIN (ANALYZE, BUFFERS)
SELECT user_id, name
FROM cinema.users
WHERE preferences @> '{"genre": "Action"}';
![img.png](screenshots/scan/img.png)

2)EXPLAIN (ANALYZE, BUFFERS)
SELECT user_id, name
FROM cinema.users
WHERE devices @> ARRAY['mobile'];
![img_1.png](screenshots/scan/img_1.png)

3)EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE tags @> ARRAY['classic'];
![img_2.png](screenshots/scan/img_2.png)

4)EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE technical_info ? 'resolution';
![img_3.png](screenshots/scan/img_3.png)

5)EXPLAIN (ANALYZE, BUFFERS)
SELECT review_id
FROM cinema.review
WHERE metadata @> '{"verified": true}';
![img_4.png](screenshots/scan/img_4.png)

**-- GIST --**

1)EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id, user_id
FROM cinema.rental
WHERE rental_period && tsrange('2024-01-01', '2024-06-01');
![img_5.png](screenshots/scan/img_5.png)

2)EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id
FROM cinema.rental
WHERE rental_period <@ tsrange('2023-01-01', '2025-01-01');
![img_6.png](screenshots/scan/img_6.png)

3)EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id, viewer_location
FROM cinema.rental
WHERE viewer_location <-> point(55.75, 37.62) < 1;
![img_7.png](screenshots/scan/img_7.png)

4)EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE search_vector @@ to_tsquery('russian', 'приключение');
![img_8.png](screenshots/scan/img_8.png)

5)EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id
FROM cinema.rental
WHERE rental_period && tsrange('2024-06-01', 'infinity');
![img_9.png](screenshots/scan/img_9.png)

все результаты сканирования join запросов в csv файлах в папке joins
