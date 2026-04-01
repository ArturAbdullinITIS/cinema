-- Создаем партиционированную таблицу rental
DROP TABLE IF EXISTS cinema.rental CASCADE;

CREATE TABLE cinema.rental (
                               rental_id INTEGER GENERATED ALWAYS AS IDENTITY,
                               user_id INTEGER NOT NULL REFERENCES cinema.users(user_id),
                               movie_id INTEGER NOT NULL REFERENCES cinema.movie(movie_id),
                               rental_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               return_date TIMESTAMP,
                               price NUMERIC NOT NULL,
                               status TEXT NOT NULL,
                               is_returned BOOLEAN DEFAULT false,
                               rental_period TSRANGE,
                               viewer_location POINT
) PARTITION BY RANGE (rental_date);

-- Создаем партиции по месяцам
CREATE TABLE cinema.rental_2024_q1 PARTITION OF cinema.rental
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE cinema.rental_2024_q2 PARTITION OF cinema.rental
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE cinema.rental_2024_q3 PARTITION OF cinema.rental
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE cinema.rental_2024_q4 PARTITION OF cinema.rental
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Создаем индексы на партициях
CREATE INDEX idx_rental_2024_q1_user_id ON cinema.rental_2024_q1(user_id);
CREATE INDEX idx_rental_2024_q2_user_id ON cinema.rental_2024_q2(user_id);
CREATE INDEX idx_rental_2024_q3_user_id ON cinema.rental_2024_q3(user_id);
CREATE INDEX idx_rental_2024_q4_user_id ON cinema.rental_2024_q4(user_id);

-- Запрос 1: будет использован partition pruning
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.rental
WHERE rental_date BETWEEN '2024-02-01' AND '2024-02-28';

-- Создаем LIST партиционированную таблицу
DROP TABLE IF EXISTS cinema.rental_list CASCADE;

CREATE TABLE cinema.rental_list (
                                    rental_id INTEGER GENERATED ALWAYS AS IDENTITY,
                                    user_id INTEGER NOT NULL,
                                    movie_id INTEGER NOT NULL,
                                    rental_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    return_date TIMESTAMP,
                                    price NUMERIC NOT NULL,
                                    status TEXT NOT NULL,
                                    is_returned BOOLEAN DEFAULT false
) PARTITION BY LIST (status);

-- Создаем партиции по статусам
CREATE TABLE cinema.rental_active PARTITION OF cinema.rental_list
    FOR VALUES IN ('active');

CREATE TABLE cinema.rental_returned PARTITION OF cinema.rental_list
    FOR VALUES IN ('returned');

CREATE TABLE cinema.rental_overdue PARTITION OF cinema.rental_list
    FOR VALUES IN ('overdue');

-- Запрос 2: По конкретному статусу
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.rental_list WHERE status = 'active';

-- Создаем HASH партиционированную таблицу
DROP TABLE IF EXISTS cinema.rental_hash CASCADE;

CREATE TABLE cinema.rental_hash (
                                    rental_id INTEGER GENERATED ALWAYS AS IDENTITY,
                                    user_id INTEGER NOT NULL,
                                    movie_id INTEGER NOT NULL,
                                    rental_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    return_date TIMESTAMP,
                                    price NUMERIC NOT NULL,
                                    status TEXT NOT NULL,
                                    is_returned BOOLEAN DEFAULT false
) PARTITION BY HASH (user_id);

-- Создаем 4 хэш-партиции
CREATE TABLE cinema.rental_hash_1 PARTITION OF cinema.rental_hash
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE cinema.rental_hash_2 PARTITION OF cinema.rental_hash
    FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE cinema.rental_hash_3 PARTITION OF cinema.rental_hash
    FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE cinema.rental_hash_4 PARTITION OF cinema.rental_hash
    FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Запрос 3: По конкретному user_id
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.rental_hash WHERE user_id = 12345;


SELECT * FROM pg_stat_bgwriter;


