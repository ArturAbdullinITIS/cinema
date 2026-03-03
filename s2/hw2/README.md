-- 1) -Без индекса
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.purchase
WHERE price > 15;
![img.png](screenshots/img.png)

-B tree index
![img.png](screenshots/img5.png)

-Hash
![img_5.png](screenshots/img12.png)

-- 2) Без индекса
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.users
WHERE email = 'user50000@mail.com';
![img_1.png](screenshots/img_1.png)

-B tree
![img_1.png](screenshots/img_6.png)

-Hash
![img_3.png](screenshots/img10.png)

-- 3) Без индекса
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.movie
WHERE description LIKE '%movie%';
![img_2.png](screenshots/img_2.png)
-B tree
![img.png](screenshots/img7.png)

-Hash
![img_4.png](screenshots/img11.png)


-- 4) Без индекса
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM cinema.users
WHERE name LIKE 'Admin%';
![img_3.png](screenshots/img_3.png)

-B tree
![img_1.png](screenshots/img8.png)

-Hash
![img_6.png](screenshots/img13.png)

-- 5) Без индекса
EXPLAIN (ANALYZE, BUFFERS)
SELECT v.*, m.title
FROM cinema.viewing v
JOIN cinema.movie m ON v.movie_id = m.movie_id
WHERE m.movie_id IN (100, 1000, 5000, 10000, 25000);
![img_4.png](screenshots/img_4.png)

-B tree
![img_2.png](screenshots/img9.png)

-Hash
![img_7.png](screenshots/img14.png)