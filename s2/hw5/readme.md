2a)LSN

--lsn до вставки

SELECT get_current_lsn() as lsn_before_insert;

![img.png](screenshots/img.png)

--вставка 

INSERT INTO cinema.actor (name, birth_date, country, biography)
VALUES ('Леонардо ДиКаприо', '1974-11-11', 'США', 'Известный американский актер');

--lsn после вставки

SELECT get_current_lsn() as lsn_after_insert;

![img_1.png](screenshots/img_1.png)

2b) WAL до и после коммита

BEGIN;

-- Смотрим текущую позицию в WAL

SELECT pg_current_wal_insert_lsn() as lsn_before_transaction;

![img_3.png](screenshots/img_3.png)

-- Выполняем несколько операций

INSERT INTO cinema.movie (title, release_year, director_id)
VALUES ('Дюна', 2021, 1);

INSERT INTO cinema.movie_genre (movie_id, genre_id)
VALUES (30000, 1); 

-- Смотрим LSN внутри транзакции (до commit)

SELECT pg_current_wal_insert_lsn() as lsn_during_transaction;

![img_4.png](screenshots/img_4.png)

COMMIT;

-- Смотрим LSN после commit

SELECT pg_current_wal_insert_lsn() as lsn_after_commit;

![img_5.png](screenshots/img_5.png)


2с)

![img_6.png](screenshots/img_6.png)

3a)

pg_dump -U artur -d cinema_db --schema-only > cinema_schema.sql - только схема

![img_7.png](screenshots/img_7.png)

3b)

pg_dump -U artur -d cinema_db --table=cinema.actor > cinema_actor.sql

![img_8.png](screenshots/img_8.png)





