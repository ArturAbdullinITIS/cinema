Physical streaming replication

-- Архитектура:

![img.png](img.png)

-- Поднятые инстансы:
![img_1.png](img_1.png)

docker exec -it pg-primary psql -U admin -d cinema_db - подключение к primary

![img_2.png](img_2.png)

На primary выполняем запросы:
-- Создать тестовую таблицу на primary
CREATE TABLE replication_test (
id SERIAL PRIMARY KEY,
message TEXT NOT NULL
);

INSERT INTO replication_test (message)
VALUES ('hello from primary');

![img_3.png](img_3.png)


docker exec -it pg-replica1 psql -U postgres -d cinema_db - подключение к replica1

![img_6.png](img_6.png)

![img_4.png](img_4.png)

![img_7.png](img_7.png)

docker exec pg-replica2 psql -U postgres -d cinema_db  - подключение к replica2

![img_5.png](img_5.png)

![img_8.png](img_8.png)

![img_7.png](img_7.png)

-- Анализ Replication Lag

docker exec -it pg-primary psql -U postgres -d cinema_db

SELECT application_name,
state,
sync_state,
write_lag,
flush_lag,
replay_lag,
pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS byte_lag
FROM pg_stat_replication;

![img_9.png](img_9.png)

-- Нагрузка на primary (300_000 строк)
CREATE TABLE IF NOT EXISTS load_test (
id SERIAL PRIMARY KEY,
payload TEXT NOT NULL,
created_at TIMESTAMP DEFAULT now()
);

INSERT INTO load_test (payload)
SELECT repeat(md5(random()::text), 20)
FROM generate_series(1, 300000);

![img_10.png](img_10.png)

![img_11.png](img_11.png)

данные на реплики дошли 

Logical Replication

![img_12.png](img_12.png)

docker exec -it pg-primary bash - разрешаем подключение в pg_hba.conf на publisher

![img_13.png](img_13.png)

docker exec -it pg-primary psql -U postgres -d cinema_db - создаем на publisher таблицы и publication

CREATE TABLE logical_test (
id INT PRIMARY KEY,
message TEXT NOT NULL
);

CREATE PUBLICATION demo_pub FOR TABLE logical_test;

docker exec -it pg-logical-sub psql -U postgres -d cinema_db - подключение к subscriber

CREATE TABLE logical_test (
id INT PRIMARY KEY,
message TEXT NOT NULL
); - создаем на subscriber таблицу

docker exec -it pg-logical-sub psql -U postgres -d cinema_db - создаем subscription

CREATE SUBSCRIPTION demo_sub
CONNECTION 'host=primary port=5432 dbname=cinema_db user=postgres password=postgres'
PUBLICATION demo_pub;

![img_14.png](img_14.png)

docker exec -it pg-primary psql -U postgres -d cinema_db - вставляем данные на publisher

INSERT INTO logical_test (id, message)
VALUES (1, 'hello logical replication');

SELECT * FROM logical_test;

![img_15.png](img_15.png)

docker exec -it pg-logical-sub psql -U postgres -d cinema_db - проверяем данные на subscriber

![img_16.png](img_16.png)

-- DDL не реплицируется, проверяем

docker exec -it pg-primary psql -U postgres -d cinema_db

![img_17.png](img_17.png)

docker exec -it pg-logical-sub psql -U postgres -d cinema_db - проверяем структуру таблицы на subscriber

![img_18.png](img_18.png)

--Проверка REPLICA IDENTITY

docker exec -it pg-primary psql -U postgres -d cinema_db - Таблица без PK на publisher

CREATE TABLE no_pk_test (
a INT,
b TEXT
);

ALTER PUBLICATION demo_pub ADD TABLE no_pk_test;

docker exec -it pg-logical-sub psql -U postgres -d cinema_db

CREATE TABLE no_pk_test (
a INT,
b TEXT
);

docker exec -it pg-primary psql -U postgres -d cinema_db - insert работает на publisher

INSERT INTO no_pk_test (a, b) VALUES (1, 'first');
SELECT * FROM no_pk_test;

![img_19.png](img_19.png)

docker exec -it pg-logical-sub psql -U postgres -d cinema_db

![img_20.png](img_20.png)

docker exec -it pg-primary psql -U postgres -d cinema_db

UPDATE no_pk_test
SET b = 'updated'
WHERE a = 1; - ошибка, нет replica identity

![img_21.png](img_21.png)

Чтобы это исправить, на publisher и subscriber можно выставить:
ALTER TABLE no_pk_test REPLICA IDENTITY FULL;

-- Проверка replication status

docker exec -it pg-logical-sub psql -U admin -d cinema_db

SELECT subname,
pid,
relid::regclass,
received_lsn,
latest_end_lsn,
latest_end_time
FROM pg_stat_subscription;

![img_22.png](img_22.png)

-- Как пригодятся pg_dump / pg_restore

Logical replication не реплицирует DDL и схему, поэтому pg_dump --schema-only удобен, чтобы быстро создать на subscriber совместимую схему до создания subscription.























