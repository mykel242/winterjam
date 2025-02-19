// routes/api.js
const express = require("express");
const router = express.Router();

// ✅ List Available Endpoints
router.get("/", (req, res) => {
  res.json({
    endpoints: [
      { method: "GET", path: "/api/users", description: "Retrieve all users" },
      {
        method: "GET",
        path: "/api/users/:id",
        description: "Retrieve a user by ID",
      },
      { method: "POST", path: "/api/users", description: "Create a new user" },
      { method: "PUT", path: "/api/users/:id", description: "Update a user" },
      {
        method: "DELETE",
        path: "/api/users/:id",
        description: "Delete a user",
      },
    ],
  });
});

// ✅ GET /api/users - Retrieve all users
router.get("/users", async (req, res, next) => {
  try {
    const result = await req.db.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// ✅ GET /api/users/:id - Retrieve a user by ID
router.get("/users/:id", async (req, res, next) => {
  const { id } = req.params;
  try {
    const result = await req.db.query(
      "SELECT * FROM users WHERE id::STRING = $1",
      [id],
    );
    if (result.rows.length === 0)
      return res.status(404).json({ error: "User not found" });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// ✅ POST /api/users - Create a new user
router.post("/users", async (req, res, next) => {
  const { name, email } = req.body;
  if (!name || !email)
    return res.status(400).json({ error: "name and email are required" });

  try {
    const result = await req.db.query(
      "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *",
      [name, email],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// ✅ PUT /api/users/:id - Update a user
router.put("/users/:id", async (req, res, next) => {
  const { id } = req.params;
  const { name, email } = req.body;
  if (!name || !email)
    return res.status(400).json({ error: "name and email are required" });

  try {
    const result = await req.db.query(
      "UPDATE users SET name = $1, email = $2 WHERE id::STRING = $3 RETURNING *",
      [name, email, id],
    );
    if (result.rows.length === 0)
      return res.status(404).json({ error: "User not found" });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// ✅ DELETE /api/users/:id - Remove a user
router.delete("/users/:id", async (req, res, next) => {
  const { id } = req.params;
  try {
    const result = await req.db.query(
      "DELETE FROM users WHERE id::STRING = $1 RETURNING *",
      [id],
    );
    if (result.rows.length === 0)
      return res.status(404).json({ error: "User not found" });
    res.json({ message: "User deleted successfully" });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
