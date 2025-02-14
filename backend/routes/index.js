// routes/index.js
const express = require("express");
const router = express.Router();

// Base route - for testing
router.get("/", (req, res) => {
  res.send("Hello World");
});

router.get("/test", (req, res) => {
  res.send("Test route works!");
});

// Mount API endpoints
router.use("/api", require("./api"));

module.exports = router;
