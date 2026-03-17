--2a)
CREATE OR REPLACE FUNCTION get_current_lsn()
    RETURNS pg_lsn AS $$
BEGIN
    RETURN pg_current_wal_insert_lsn();
END;
$$ LANGUAGE plpgsql;

SELECT get_current_lsn() as lsn_before_insert;

INSERT INTO cinema.actor (name, birth_date, country, biography)
VALUES ('Леонардо ДиКаприо', '1974-11-11', 'США', 'Известный американский актер');

SELECT get_current_lsn() as lsn_after_insert;



-- 2b)
BEGIN;

SELECT pg_current_wal_insert_lsn() as lsn_before_transaction;

INSERT INTO cinema.movie (title, release_year, director_id)
VALUES ('Дюна', 2021, 1);

INSERT INTO cinema.movie_genre (movie_id, genre_id)
VALUES (30000, 1);

SELECT pg_current_wal_insert_lsn() as lsn_during_transaction;

COMMIT;

SELECT pg_current_wal_insert_lsn() as lsn_after_commit;

-- 2c)
CREATE OR REPLACE FUNCTION analyze_wal_growth(operation_description text)
    RETURNS TABLE(
                     stage text,
                     lsn_value pg_lsn,
                     wal_size_bytes numeric
                 ) AS $$
DECLARE
    start_lsn pg_lsn;
    mid_lsn pg_lsn;
    end_lsn pg_lsn;
    start_size numeric;
    mid_size numeric;
    end_size numeric;
    i integer;
BEGIN
    start_lsn := pg_current_wal_insert_lsn();
    start_size := pg_wal_lsn_diff(start_lsn, '0/00000000');

    stage := 'Начало';
    lsn_value := start_lsn;
    wal_size_bytes := start_size;
    RETURN NEXT;

    FOR i IN 1..1000 LOOP
            INSERT INTO cinema.movie (title, release_year, duration, director_id)
            VALUES ('Тестовый фильм ' || i, 2023, 120, 1);
        END LOOP;

    mid_lsn := pg_current_wal_insert_lsn();
    mid_size := pg_wal_lsn_diff(mid_lsn, '0/00000000');

    stage := 'После вставки 1000 записей';
    lsn_value := mid_lsn;
    wal_size_bytes := mid_size;
    RETURN NEXT;

    end_lsn := pg_current_wal_insert_lsn();
    end_size := pg_wal_lsn_diff(end_lsn, '0/00000000');

    stage := 'После всех операций';
    lsn_value := end_lsn;
    wal_size_bytes := end_size;
    RETURN NEXT;

    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM analyze_wal_growth('Массовая вставка фильмов');

-- 4a)
INSERT INTO cinema.genre (name, description) VALUES
                                                 ('Action', 'Фильмы с интенсивными боевыми сценами, погонями и взрывами'),
                                                 ('Comedy', 'Фильмы, созданные для смеха и развлечения'),
                                                 ('Drama', 'Серьезные фильмы с глубоким сюжетом и эмоциональным напряжением'),
                                                 ('Sci-Fi', 'Научно-фантастические фильмы о будущем и технологиях'),
                                                 ('Horror', 'Фильмы ужасов, созданные для запугивания зрителей'),
                                                 ('Romance', 'Романтические фильмы о любовных отношениях'),
                                                 ('Thriller', 'Напряженные фильмы с неожиданными поворотами сюжета'),
                                                 ('Documentary', 'Документальные фильмы о реальных событиях')
ON CONFLICT (genre_id) DO NOTHING;

INSERT INTO cinema.director (name, birth_date, country, biography) VALUES
                                                                       ('Кристофер Нолан', '1970-07-30', 'Великобритания',
                                                                        'Известен своими сложными сюжетами и визуальным стилем. Режиссер "Темного рыцаря", "Начала", "Интерстеллара"'),
                                                                       ('Квентин Тарантино', '1963-03-27', 'США',
                                                                        'Знаменит нелинейным повествованием и стильными диалогами. Режиссер "Криминального чтива", "Убить Билла"'),
                                                                       ('Джеймс Кэмерон', '1954-08-16', 'Канада',
                                                                        'Пионер в использовании спецэффектов. Режиссер "Титаника", "Аватара", "Терминатора"'),
                                                                       ('Гай Ричи', '1968-09-10', 'Великобритания',
                                                                        'Известен криминальными комедиями и стилем. Режиссер "Карты, деньги, два ствола", "Шерлок Холмс"'),
                                                                       ('Питер Джексон', '1961-10-31', 'Новая Зеландия',
                                                                        'Режиссер трилогии "Властелин колец" и "Хоббит"')
ON CONFLICT (director_id) DO NOTHING;

INSERT INTO cinema.actor (name, birth_date, country, biography) VALUES
                                                                    ('Леонардо ДиКаприо', '1974-11-11', 'США',
                                                                     'Обладатель Оскара, известен ролями в "Титанике", "Выжившем", "Начале"'),
                                                                    ('Том Хэнкс', '1956-07-09', 'США',
                                                                     'Легендарный актер, известный по фильмам "Форрест Гамп", "Изгой", "Спасти рядового Райана"'),
                                                                    ('Скарлетт Йоханссон', '1984-11-22', 'США',
                                                                     'Известна ролями в фильмах Marvel, "Трудности перевода", "Она"'),
                                                                    ('Киану Ривз', '1964-09-02', 'Ливан',
                                                                     'Звезда "Матрицы" и "Джона Уика", известен своей скромностью'),
                                                                    ('Мэрил Стрип', '1949-06-22', 'США',
                                                                     'Самая номинируемая актриса в истории, известна разноплановыми ролями'),
                                                                    ('Роберт Дауни мл.', '1965-04-04', 'США',
                                                                     'Известен ролью Железного человека в Marvel и Шерлока Холмса'),
                                                                    ('Кристиан Бэйл', '1974-01-30', 'Великобритания',
                                                                     'Известен трансформациями для ролей в "Машинисте", "Темном рыцаре"')
ON CONFLICT (actor_id) DO NOTHING;

INSERT INTO cinema.users (name, email, password_hash, role, date_created) VALUES
                                                                              ('Иван Петров', 'ivan@email.com', 'hash123456', 'user', CURRENT_TIMESTAMP),
                                                                              ('Мария Сидорова', 'maria@email.com', 'hash789012', 'user', CURRENT_TIMESTAMP),
                                                                              ('Admin User', 'admin@cinema.com', 'adminhash123', 'admin', CURRENT_TIMESTAMP),
                                                                              ('Алексей Иванов', 'alexey@email.com', 'hash345678', 'user', CURRENT_TIMESTAMP),
                                                                              ('Елена Козлова', 'elena@email.com', 'hash901234', 'user', CURRENT_TIMESTAMP)
ON CONFLICT (user_id) DO UPDATE SET
    last_login = EXCLUDED.last_login;
