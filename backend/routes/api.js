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
        path: "/api/users/:uuid",
        description: "Retrieve a user by UUID",
      },
      { method: "POST", path: "/api/users", description: "Create a new user" },
      { method: "PUT", path: "/api/users/:uuid", description: "Update a user" },
      {
        method: "DELETE",
        path: "/api/users/:uuid",
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

// ✅ GET /api/users/:uuid - Retrieve a user by UUID
router.get("/users/:uuid", async (req, res, next) => {
  const { uuid } = req.params;

  // Debug log to verify incoming UUID
  console.log("🔍 Received UUID:", uuid, typeof uuid); // Ensure it's a string

  try {
    const result = await req.db.query(
      "SELECT * FROM users WHERE uuid = $1",
      [uuid], // No casting needed, pg will handle it
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error("❌ Error fetching user:", err.message);
    next(err);
  }
});

// ✅ POST /api/users - Create a new user
router.post("/users", async (req, res, next) => {
  const { name, email } = req.body;
  if (!name || !email)
    return res.status(400).json({ error: "name and email are required" });

  try {
    // ✅ Insert without specifying id (uuid is auto-generated)
    const result = await req.db.query(
      "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *",
      [name, email],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// ✅ PUT /api/users/:uuid - Update a user
router.put("/users/:uuid", async (req, res, next) => {
  const { uuid } = req.params;
  const { name, email } = req.body;
  // Debug log to verify incoming UUID
  console.log("🔍 Received UUID:", uuid, typeof uuid); // Ensure it's a string
  if (!name || !email)
    return res.status(400).json({ error: "name and email are required" });

  try {
    const result = await req.db.query(
      "UPDATE users SET name = $1, email = $2 WHERE uuid = $3 RETURNING *",
      [name, email, uuid],
    );
    if (result.rows.length === 0)
      return res.status(404).json({ error: "User not found" });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// ✅ DELETE /api/users/:uuid - Remove a user
router.delete("/users/:uuid", async (req, res, next) => {
  const { uuid } = req.params;
  // Debug log to verify incoming UUID
  console.log("🔍 Received UUID:", uuid, typeof uuid); // Ensure it's a string

  try {
    const result = await req.db.query(
      "DELETE FROM users WHERE uuid = $1 RETURNING *",
      [uuid],
    );
    if (result.rows.length === 0)
      return res.status(404).json({ error: "User not found" });
    res.json({ message: "User deleted successfully" });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
