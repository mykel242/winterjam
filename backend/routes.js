const express = require("express");
const pool = require("./db");
const router = express.Router();

// router.get("/", (req, res) => {
//   res.html("Running => Node.js / express.js\n\n");
// });

// 📌 Create a User
router.post("/users", async (req, res) => {
  try {
    const { name, email } = req.body;
    const newUser = await pool.query(
      "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *",
      [name, email],
    );
    res.json(newUser.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Get All Users
router.get("/users", async (req, res) => {
  try {
    const allUsers = await pool.query("SELECT * FROM users");
    res.json(allUsers.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Get a Single User by ID
router.get("/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const user = await pool.query("SELECT * FROM users WHERE id = $1", [id]);
    res.json(user.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Update a User by ID
router.put("/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email } = req.body;
    const updatedUser = await pool.query(
      "UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING *",
      [name, email, id],
    );
    res.json(updatedUser.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Delete a User by ID
router.delete("/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query("DELETE FROM users WHERE id = $1", [id]);
    res.json({ message: "User deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
