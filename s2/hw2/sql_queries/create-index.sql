-- B-tree индексы
CREATE INDEX idx_purchase_price_btree ON cinema.purchase USING btree (price);
CREATE INDEX idx_users_email_btree ON cinema.users USING btree (email);
CREATE INDEX idx_users_name_btree ON cinema.users (name text_pattern_ops);
CREATE INDEX idx_movie_description_btree ON cinema.movie USING btree (description);
CREATE INDEX idx_viewing_movie_id_btree ON cinema.viewing USING btree (movie_id);
CREATE INDEX idx_movie_id_btree ON cinema.movie USING btree (movie_id);

-- Hash индексы
CREATE INDEX idx_purchase_price_hash ON cinema.purchase USING hash (price);
CREATE INDEX idx_users_email_hash ON cinema.users USING hash (email);
CREATE INDEX idx_users_name_hash ON cinema.users USING hash (name);
CREATE INDEX idx_viewing_movie_id_hash ON cinema.viewing USING hash (movie_id);



