-- default_data.sql

-- Create a sample database and table, then insert some data:
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY,
    name STRING,
    email STRING
);

INSERT INTO users (id, name, email)
VALUES
  (1, 'Alice', 'alice@example.com'),
  (2, 'Bob', 'bob@example.com'),
  (3, 'Charlie', 'charlie@example.com')
ON CONFLICT DO NOTHING;
