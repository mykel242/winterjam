CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

-- Fix: Make `id` auto-generate
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY DEFAULT unique_rowid(),  -- CockroachDB-specific ID generator
    name STRING NOT NULL,
    email STRING UNIQUE NOT NULL
);

INSERT INTO users (name, email)
VALUES
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com'),
  ('Charlie', 'charlie@example.com')
ON CONFLICT DO NOTHING;
