-- Создание GIST индексов
CREATE INDEX IF NOT EXISTS idx_rental_period ON cinema.rental USING GIST (rental_period);
CREATE INDEX IF NOT EXISTS idx_rental_location ON cinema.rental USING GIST (viewer_location);
-- Для FTS
ALTER TABLE cinema.movie ADD COLUMN IF NOT EXISTS search_vector TSVECTOR;
UPDATE cinema.movie SET search_vector = to_tsvector('russian', COALESCE(title, '') || ' ' || COALESCE(description, ''));
CREATE INDEX IF NOT EXISTS idx_movie_search_vector ON cinema.movie USING GIST (search_vector);

-- Сканирование
-- 1. Найти аренды за период
EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id, user_id
FROM cinema.rental
WHERE rental_period && tsrange('2024-01-01', '2024-06-01');
-- 2. Найти аренды, целиком входящие в период
EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id
FROM cinema.rental
WHERE rental_period <@ tsrange('2023-01-01', '2025-01-01');
-- 3. Найти аренды в точке просмотра рядом с координатами
EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id, viewer_location
FROM cinema.rental
WHERE viewer_location <-> point(55.75, 37.62) < 1;
-- 4. Полнотекстовый поиск по фильмам через GiST
EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE search_vector @@ to_tsquery('russian', 'приключение');
-- 5. Найти аренды, которые начинаются после определённой даты
EXPLAIN (ANALYZE, BUFFERS)
SELECT rental_id
FROM cinema.rental
WHERE rental_period && tsrange('2024-06-01', 'infinity');