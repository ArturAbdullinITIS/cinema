CREATE SCHEMA IF NOT EXISTS cinema;

-- 1. Роль администратора (полный доступ)
CREATE ROLE admin_user WITH
    LOGIN
    PASSWORD 'admin_pass_123'
    SUPERUSER
    CREATEDB
    CREATEROLE;

-- 2. Роль менеджера контента (может управлять фильмами, актерами и т.д.)
CREATE ROLE content_manager WITH
    LOGIN
    PASSWORD 'manager_pass_123'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE;

-- 3. Роль аналитика (только чтение)
CREATE ROLE analyst_user WITH
    LOGIN
    PASSWORD 'analyst_pass_123'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE;

-- 4. Роль поддержки (может видеть пользователей и их активность)
CREATE ROLE support_user WITH
    LOGIN
    PASSWORD 'support_pass_123'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE;

GRANT CONNECT ON DATABASE cinema_db TO content_manager, analyst_user, support_user;
GRANT USAGE ON SCHEMA cinema TO content_manager, analyst_user, support_user;

-- Права для content_manager (полный CRUD на таблицы с контентом)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cinema TO content_manager;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA cinema TO content_manager;

-- Ограничиваем доступ к финансовым данным
REVOKE ALL ON cinema.purchase, cinema.subscription FROM content_manager;
GRANT SELECT ON cinema.purchase, cinema.subscription TO content_manager;

-- Права для analyst_user (только SELECT)
GRANT SELECT ON ALL TABLES IN SCHEMA cinema TO analyst_user;

-- Права для support_user (видят пользователей и просмотры, но не финансы)
GRANT SELECT ON cinema.users, cinema.viewing, cinema.rental, cinema.review TO support_user;
GRANT UPDATE (last_login, role) ON cinema.users TO support_user;

-- Даем права на будущие таблицы
ALTER DEFAULT PRIVILEGES IN SCHEMA cinema
    GRANT SELECT ON TABLES TO analyst_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA cinema
    GRANT ALL PRIVILEGES ON TABLES TO content_manager;