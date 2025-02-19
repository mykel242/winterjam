CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

-- Ensure id is auto-generated, and each user gets a unique UUID
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY DEFAULT unique_rowid (), -- Auto-generated unique integer ID
    uuid UUID DEFAULT gen_random_uuid (), -- Unique UUID assigned automatically
    name STRING NOT NULL,
    email STRING UNIQUE NOT NULL
);

-- Insert initial data (no need to specify id or uuid)
INSERT INTO
    users (name, email)
VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com') ON CONFLICT DO NOTHING;
