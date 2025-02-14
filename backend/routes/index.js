// routes/index.js
const express = require("express");
const router = express.Router();

// Base route - for testing
router.get("/", (req, res) => {
  res.send("Hello World");
});

// Mount API endpoints
router.use("/api", require("./api"));

module.exports = router;
