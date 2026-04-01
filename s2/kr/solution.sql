--1
EXPLAIN SELECT id, user_id, amount, created_at
FROM exam_events
WHERE user_id = 4242
  AND created_at >= TIMESTAMP '2025-03-10 00:00:00'
  AND created_at < TIMESTAMP '2025-03-11 00:00:00';

CREATE INDEX idx_exam_events_range ON exam_events(created_at);

--2
EXPLAIN ANALYZE
SELECT u.id, u.country, o.amount, o.created_at
FROM exam_users u
         JOIN exam_orders o ON o.user_id = u.id
WHERE u.country = 'JP'
  AND o.created_at >= TIMESTAMP '2025-03-01 00:00:00'
  AND o.created_at < TIMESTAMP '2025-03-08 00:00:00';

CREATE INDEX idx_exam_users_country on exam_users(country)

--3
SELECT xmin, xmax, ctid, id, title, qty
FROM exam_mvcc_items
ORDER BY id;

UPDATE exam_mvcc_items
SET qty = qty + 6
WHERE id = 1;

SELECT xmin, xmax, ctid, id, title, qty
FROM exam_mvcc_items
ORDER BY id;

DELETE FROM exam_mvcc_items
WHERE id = 2;

SELECT xmin, xmax, ctid, id, title, qty
FROM exam_mvcc_items
ORDER BY id;

BEGIN;
SELECT * FROM exam_lock_items WHERE id = 1 FOR UPDATE;
