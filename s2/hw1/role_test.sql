-- Cinema Reader
-- Success:
SELECT * FROM cinema.users LIMIT 5;
SELECT * FROM cinema.movie LIMIT 5;
SELECT * FROM cinema.review LIMIT 5;

-- Error:
INSERT INTO cinema.users (name, email, password_hash, role) VALUES ('Test', 'test@test.com', 'hash', 'user');
UPDATE cinema.users SET name = 'New' WHERE user_id = 1;
DELETE FROM cinema.review WHERE review_id = 1;



-- Cinema Editor
-- Success:
SELECT * FROM cinema.users LIMIT 5;
SELECT * FROM cinema.movie LIMIT 5;

INSERT INTO cinema.users (name, email, password_hash, role) VALUES ('Editor', 'editor@test.com', 'hash', 'user');
INSERT INTO cinema.review (user_id, movie_id, rating, comment) VALUES (1, 1, 5, 'Good');

-- Error:
UPDATE cinema.users SET name = 'New' WHERE user_id = 1;
DELETE FROM cinema.review WHERE review_id = 1;
DROP TABLE cinema.genre;


-- Cinema Admin
-- Success:
SELECT * FROM cinema.users LIMIT 5;

INSERT INTO cinema.users (name, email, password_hash, role) VALUES ('Admin', 'admin@test.com', 'hash', 'admin');
UPDATE cinema.users SET name = 'Updated' WHERE email = 'admin@test.com';
DELETE FROM cinema.users WHERE email = 'admin@test.com';

INSERT INTO cinema.genre (name, description) VALUES ('Test', 'Test desc');
DELETE FROM cinema.genre WHERE name = 'Test';