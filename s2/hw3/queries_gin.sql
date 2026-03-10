-- Создание GIN индексов
CREATE INDEX IF NOT EXISTS idx_users_preferences ON cinema.users USING GIN (preferences);
CREATE INDEX IF NOT EXISTS idx_users_devices ON cinema.users USING GIN (devices);
CREATE INDEX IF NOT EXISTS idx_movie_technical_info ON cinema.movie USING GIN (technical_info);
CREATE INDEX IF NOT EXISTS idx_movie_tags ON cinema.movie USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_review_metadata ON cinema.review USING GIN (metadata);

-- Сканирование
-- 1. JSONB поиск по жанру "Action"
EXPLAIN (ANALYZE, BUFFERS)
SELECT user_id, name
FROM cinema.users
WHERE preferences @> '{"genre": "Action"}';
-- 2. Найти mobile устройства
EXPLAIN (ANALYZE, BUFFERS)
SELECT user_id, name
FROM cinema.users
WHERE devices @> ARRAY['mobile'];
-- 3. Найти фильмы с тегом "classic"
EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE tags @> ARRAY['classic'];
-- 4. Найти фильмы, где technical_info содержит ключ 'resolution'
EXPLAIN (ANALYZE, BUFFERS)
SELECT movie_id, title
FROM cinema.movie
WHERE technical_info ? 'resolution';
-- 5. Найти отзывы, где metadata содержит 'verified': true
EXPLAIN (ANALYZE, BUFFERS)
SELECT review_id
FROM cinema.review
WHERE metadata @> '{"verified": true}';
