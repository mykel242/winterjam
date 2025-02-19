// server.js
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const { Pool, types } = require("pg");
const routes = require("./routes");

// Load environment variables
dotenv.config();

const PORT = process.env.PORT || 3000;
const app = express();

// ✅ Enable CORS (for frontend communication)
app.use(cors());

// ✅ Enable JSON parsing
app.use(express.json());

// ✅ Request Logging Middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// ✅ Set up CockroachDB Connection (Moved from `api.js`)
types.setTypeParser(23, (val) => parseInt(val, 10)); // Ensure integer parsing
types.setTypeParser(20, (val) => parseInt(val, 10));

const pool = new Pool({
  user: process.env.DB_USER || "root",
  host: process.env.DB_HOST || "cockroachdb",
  database: process.env.DB_NAME || "mydb",
  port: process.env.DB_PORT || 26257,
  ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: false } : false,
});

pool
  .connect()
  .then(() => console.log("✅ Connected to CockroachDB"))
  .catch((err) => console.error("❌ DB Connection Error:", err));

// ✅ Pass DB Pool to Routes
app.use((req, res, next) => {
  req.db = pool;
  next();
});

// Mount all routes
app.use("/", routes);

// ✅ Centralized Error Handling
app.use((err, req, res, next) => {
  console.error("Server Error:", err.message);
  res.status(500).json({ error: "Internal Server Error" });
});

// ✅ Start Server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
  });
}

module.exports = { app, pool };
