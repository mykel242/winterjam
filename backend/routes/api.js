// routes/api.js

const express = require("express");
const router = express.Router();
const { Pool, types } = require("pg");
// For PostgreSQL INT4 (OID 23) and possibly INT8 (OID 20)
types.setTypeParser(23, (val) => parseInt(val, 10));
types.setTypeParser(20, (val) => parseInt(val, 10));

// Configure the database connection.
const pool = new Pool({
  host: process.env.DB_IP || "localhost",
  port: process.env.DB_PORT || 26257,
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "mydb",
  ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: false } : false,
});

console.log("Connecting to DB at:", process.env.DB_IP || "localhost");

// Function to generate endpoints list
const getEndpointsList = () => [
  {
    method: "GET",
    path: "/api",
    description: "List all available API endpoints",
  },
  {
    method: "GET",
    path: "/api/users",
    description: "Retrieve all users",
  },
  {
    method: "GET",
    path: "/api/users/:id",
    description: "Retrieve a specific user by ID",
  },
  {
    method: "POST",
    path: "/api/users",
    description: "Create a new user",
  },
  {
    method: "PUT",
    path: "/api/users/:id",
    description: "Update an existing user",
  },
  {
    method: "DELETE",
    path: "/api/users/:id",
    description: "Delete a user",
  },
];

// New endpoint: GET /api returns a list of available API endpoints.
router.get("/", (req, res) => {
  res.json({ endpoints: getEndpointsList() });
});

// Also keep the existing /api/endpoints route.
router.get("/endpoints", (req, res) => {
  res.json({ endpoints: getEndpointsList() });
});

// --- CRUD Endpoints for "users" ---

// GET /api/users - Retrieve all users
router.get("/users", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching users:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// GET /api/users/:id - Retrieve a specific user by id
router.get("/users/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query("SELECT * FROM users WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error fetching user:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// POST /api/users - Create a new user
// Expects a JSON body with: { "id": number, "name": string, "email": string }
router.post("/users", async (req, res) => {
  const { id, name, email } = req.body;
  if (!id || !name || !email) {
    return res.status(400).json({ error: "id, name, and email are required" });
  }
  try {
    const result = await pool.query(
      "INSERT INTO users (id, name, email) VALUES ($1, $2, $3) RETURNING *",
      [id, name, email],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("Error creating user:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// PUT /api/users/:id - Update an existing user
// Expects a JSON body with: { "name": string, "email": string }
router.put("/users/:id", async (req, res) => {
  const { id } = req.params;
  const { name, email } = req.body;
  if (!name || !email) {
    return res.status(400).json({ error: "name and email are required" });
  }
  try {
    const result = await pool.query(
      "UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING *",
      [name, email, id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error updating user:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// DELETE /api/users/:id - Delete a user
router.delete("/users/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      "DELETE FROM users WHERE id = $1 RETURNING *",
      [id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (err) {
    console.error("Error deleting user:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

router.pool = pool;
module.exports = router;
