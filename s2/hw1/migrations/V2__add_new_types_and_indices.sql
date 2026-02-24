-- new types
ALTER TABLE cinema.users
    ADD COLUMN IF NOT EXISTS preferences JSONB,
    ADD COLUMN IF NOT EXISTS watch_history JSONB,
    ADD COLUMN IF NOT EXISTS devices TEXT[];

ALTER TABLE cinema.movie
    ADD COLUMN IF NOT EXISTS technical_info JSONB,
    ADD COLUMN IF NOT EXISTS available_formats TEXT[],
    ADD COLUMN IF NOT EXISTS tags TEXT[];

ALTER TABLE cinema.review
    ADD COLUMN IF NOT EXISTS likes_history INTEGER[],
    ADD COLUMN IF NOT EXISTS metadata JSONB;

ALTER TABLE cinema.rental
    ADD COLUMN IF NOT EXISTS rental_period TSRANGE,
    ADD COLUMN IF NOT EXISTS viewer_location POINT;
-- indices
CREATE INDEX IF NOT EXISTS idx_users_preferences ON cinema.users USING GIN (preferences);
CREATE INDEX IF NOT EXISTS idx_users_devices ON cinema.users USING GIN (devices);
CREATE INDEX IF NOT EXISTS idx_movie_tech_info ON cinema.movie USING GIN (technical_info);
CREATE INDEX IF NOT EXISTS idx_movie_tags ON cinema.movie USING GIN (tags);
CREATE INDEX IF NOT EXISTS idx_review_metadata ON cinema.review USING GIN (metadata);
CREATE INDEX IF NOT EXISTS idx_rental_period ON cinema.rental USING GIST (rental_period);
CREATE INDEX IF NOT EXISTS idx_rental_location ON cinema.rental USING GIST (viewer_location);