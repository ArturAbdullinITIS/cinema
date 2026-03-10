-- 1. INNER JOIN: пользователи и их аренды (с деталями фильма)
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.name, m.title, r.rental_date, r.price
FROM cinema.rental r
         INNER JOIN cinema.users u ON r.user_id = u.user_id
         INNER JOIN cinema.movie m ON r.movie_id = m.movie_id
ORDER BY r.rental_date DESC
LIMIT 100;
-- 2. LEFT JOIN: все фильмы и их отзывы (включая фильмы без отзывов)
EXPLAIN (ANALYZE, BUFFERS)
SELECT m.title, COUNT(rv.review_id) AS review_count, AVG(rv.rating) AS avg_rating
FROM cinema.movie m
         LEFT JOIN cinema.review rv ON m.movie_id = rv.movie_id
GROUP BY m.movie_id, m.title
ORDER BY review_count DESC
LIMIT 50;
-- 3. JOIN трёх таблиц: покупки пользователей с жанром фильма
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.name, m.title, g.name AS genre, p.price
FROM cinema.purchase p
         INNER JOIN cinema.users u ON p.user_id = u.user_id
         INNER JOIN cinema.movie m ON p.movie_id = m.movie_id
         INNER JOIN cinema.movie_genre mg ON m.movie_id = mg.movie_id
         INNER JOIN cinema.genre g ON mg.genre_id = g.genre_id
LIMIT 100;
-- 4. JOIN с подзапросом: топ-10 пользователей по количеству просмотров
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.name, v.view_count
FROM cinema.users u
         INNER JOIN (
    SELECT user_id, COUNT(*) AS view_count
    FROM cinema.viewing
    GROUP BY user_id
    ORDER BY view_count DESC
    LIMIT 10
) v ON u.user_id = v.user_id;
-- 5. JOIN для анализа активных подписок и их аренд
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.name, s.plan_type, COUNT(r.rental_id) AS rental_count
FROM cinema.users u
         INNER JOIN cinema.subscription s ON u.user_id = s.user_id
         LEFT JOIN cinema.rental r ON u.user_id = r.user_id
WHERE s.status = 'active'
GROUP BY u.user_id, u.name, s.plan_type
ORDER BY rental_count DESC
LIMIT 50;