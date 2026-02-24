TRUNCATE cinema.viewing, cinema.review, cinema.rental, cinema.purchase,
    cinema.movie_actor, cinema.movie_genre, cinema.family_member,
    cinema.family_group, cinema.subscription, cinema.movie,
    cinema.actor, cinema.director, cinema.genre, cinema.users
    RESTART IDENTITY CASCADE;

-- 1. Жанры (низкая кардинальность - 15 штук)
INSERT INTO cinema.genre (name, description) VALUES
                                                 ('Action', 'Боевики с перестрелками'),
                                                 ('Comedy', 'Комедии для смеха'),
                                                 ('Drama', 'Драмы про жизнь'),
                                                 ('Horror', 'Ужасы страшные'),
                                                 ('Sci-Fi', 'Фантастика про будущее'),
                                                 ('Romance', 'Романтика про любовь'),
                                                 ('Thriller', 'Триллеры напряженные'),
                                                 ('Documentary', 'Документальное кино'),
                                                 ('Fantasy', 'Фэнтези с магией'),
                                                 ('Animation', 'Мультфильмы'),
                                                 ('Adventure', 'Приключения'),
                                                 ('Crime', 'Криминал'),
                                                 ('Mystery', 'Мистика'),
                                                 ('Western', 'Вестерны'),
                                                 ('Musical', 'Мюзиклы');

-- 2. Режиссеры (1000 штук)
INSERT INTO cinema.director (name, birth_date, country, biography)
SELECT
    'Director_' || generate_series as name,
    DATE '1950-01-01' + (random() * 365 * 50)::int as birth_date,
    CASE (random() * 4)::int
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'UK'
        WHEN 2 THEN 'France'
        WHEN 3 THEN 'Germany'
        ELSE 'Italy'
        END as country,
    'Biography text for director ' || generate_series as biography
FROM generate_series(1, 1000);

-- 3. Актеры (5000 штук)
INSERT INTO cinema.actor (name, birth_date, country, biography)
SELECT
    'Actor_' || generate_series as name,
    DATE '1960-01-01' + (random() * 365 * 40)::int as birth_date,
    CASE (random() * 3)::int
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'UK'
        ELSE 'Canada'
        END as country,
    'Actor biography ' || generate_series as biography
FROM generate_series(1, 5000);

-- 4. Пользователи (100 000)
INSERT INTO cinema.users (name, email, password_hash, role, date_created, last_login, preferences, devices, watch_history)
SELECT
    'User_' || generate_series as name,
    'user' || generate_series || '@mail.com' as email,
    md5(random()::text) as password_hash,
    CASE
        WHEN random() < 0.8 THEN 'user'
        WHEN random() < 0.95 THEN 'premium'
        ELSE 'admin'
        END as role,
    CURRENT_TIMESTAMP - (random() * interval '1 year') as date_created,
    CASE WHEN random() < 0.85
             THEN CURRENT_TIMESTAMP - (random() * interval '30 days')
         ELSE NULL
        END as last_login,
    jsonb_build_object(
            'theme', CASE WHEN random() < 0.7 THEN 'dark' ELSE 'light' END,
            'language', CASE (random() * 4)::int WHEN 0 THEN 'en' WHEN 1 THEN 'ru' ELSE 'en' END
    ) as preferences,
    ARRAY['web', 'mobile'] as devices,
    jsonb_build_object('total_watch_time', (random() * 1000)::int) as watch_history
FROM generate_series(1, 100000);

-- 5. Фильмы (50 000)
INSERT INTO cinema.movie (title, description, release_year, duration, age_rating, language, country, director_id, technical_info, available_formats, tags)
SELECT
    'Movie_' || generate_series as title,
    'Description for movie ' || generate_series as description,
    1990 + (random() * 34)::int as release_year,
    60 + (random() * 150)::int as duration,
    CASE (random() * 4)::int
        WHEN 0 THEN 'G'
        WHEN 1 THEN 'PG'
        WHEN 2 THEN 'PG-13'
        WHEN 3 THEN 'R'
        ELSE 'NC-17'
        END as age_rating,
    CASE WHEN random() < 0.7 THEN 'English' ELSE 'Other' END as language,
    CASE (random() * 4)::int WHEN 0 THEN 'USA' ELSE 'Other' END as country,
    1 + (random() * 999)::int as director_id,
    jsonb_build_object('budget', (random() * 100)::int || 'M') as technical_info,
    ARRAY['DVD', 'Blu-ray'] as available_formats,
    ARRAY['new', 'popular'] as tags
FROM generate_series(1, 50000);

-- 6. Связи фильм-актер (150 000)
INSERT INTO cinema.movie_actor (movie_id, actor_id)
SELECT
    1 + (random() * 49999)::int,
    1 + (random() * 4999)::int
FROM generate_series(1, 150000)
ON CONFLICT DO NOTHING;

-- 7. Связи фильм-жанр (100 000)
INSERT INTO cinema.movie_genre (movie_id, genre_id)
SELECT
    1 + (random() * 49999)::int,
    1 + (random() * 14)::int
FROM generate_series(1, 100000)
ON CONFLICT DO NOTHING;

-- 8. Просмотры (200 000)
INSERT INTO cinema.viewing (user_id, movie_id, viewing_date, progress, device, watched_until)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 49999)::int,
    CURRENT_TIMESTAMP - (random() * interval '6 months') as viewing_date,
    (random() * 100)::numeric(5,2) as progress,
    CASE (random() * 3)::int WHEN 0 THEN 'web' WHEN 1 THEN 'mobile' ELSE 'tv' END as device,
    CASE WHEN random() < 0.8 THEN (random() * 180)::int ELSE NULL END
FROM generate_series(1, 200000);

-- 9. Отзывы (150 000)
INSERT INTO cinema.review (user_id, movie_id, rating, comment, review_date, is_spoiler, likes_history, metadata)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 49999)::int,
    1 + (random() * 4)::int as rating,
    CASE WHEN random() < 0.85 THEN 'Comment text ' || generate_series ELSE NULL END,
    CURRENT_TIMESTAMP - (random() * interval '3 months') as review_date,
    random() < 0.1 as is_spoiler,
    ARRAY[1,2,3] as likes_history,
    jsonb_build_object('source', 'web') as metadata
FROM generate_series(1, 150000);

-- 10. Аренда (100 000)
-- =====================================================
-- 10. Аренда (100 000) - БЕЗ RANGE ТИПА
-- =====================================================
INSERT INTO cinema.rental (user_id, movie_id, rental_date, return_date, price, status, is_returned, viewer_location)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 49999)::int,
    CURRENT_TIMESTAMP - (random() * interval '90 days') as rental_date,
    CASE WHEN random() < 0.7
             THEN CURRENT_TIMESTAMP - (random() * interval '85 days')
         ELSE NULL
        END as return_date,
    (2.99 + random() * 5)::numeric(10,2) as price,
    CASE WHEN random() < 0.7 THEN 'returned' ELSE 'active' END as status,
    random() < 0.7 as is_returned,
    point((random()*180-90)::real, (random()*360-180)::real) as viewer_location
FROM generate_series(1, 100000);

-- 11. Покупки (80 000)
INSERT INTO cinema.purchase (user_id, movie_id, purchase_date, price, payment_method)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 49999)::int,
    CURRENT_TIMESTAMP - (random() * interval '180 days') as purchase_date,
    (5.99 + random() * 15)::numeric(10,2) as price,
    CASE (random() * 3)::int WHEN 0 THEN 'card' WHEN 1 THEN 'paypal' ELSE 'card' END as payment_method
FROM generate_series(1, 80000);

-- 12. Подписки (30 000)
INSERT INTO cinema.subscription (user_id, plan_type, price, start_date, end_date, status)
SELECT
    user_id,
    CASE (random() * 2)::int WHEN 0 THEN 'basic' WHEN 1 THEN 'standard' ELSE 'premium' END,
    CASE (random() * 2)::int WHEN 0 THEN 5.99 WHEN 1 THEN 9.99 ELSE 14.99 END,
    CURRENT_TIMESTAMP - (random() * interval '1 year') as start_date,
    CURRENT_TIMESTAMP + (random() * interval '6 months') as end_date,
    CASE WHEN random() < 0.8 THEN 'active' ELSE 'expired' END as status
FROM cinema.users
WHERE role IN ('premium', 'admin')
  AND random() < 0.5
LIMIT 30000;

-- ПРОВЕРКА
SELECT 'users' as table_name, COUNT(*) FROM cinema.users
UNION ALL SELECT 'director', COUNT(*) FROM cinema.director
UNION ALL SELECT 'actor', COUNT(*) FROM cinema.actor
UNION ALL SELECT 'genre', COUNT(*) FROM cinema.genre
UNION ALL SELECT 'movie', COUNT(*) FROM cinema.movie
UNION ALL SELECT 'movie_actor', COUNT(*) FROM cinema.movie_actor
UNION ALL SELECT 'movie_genre', COUNT(*) FROM cinema.movie_genre
UNION ALL SELECT 'viewing', COUNT(*) FROM cinema.viewing
UNION ALL SELECT 'review', COUNT(*) FROM cinema.review
UNION ALL SELECT 'rental', COUNT(*) FROM cinema.rental
UNION ALL SELECT 'purchase', COUNT(*) FROM cinema.purchase
UNION ALL SELECT 'subscription', COUNT(*) FROM cinema.subscription
ORDER BY table_name;