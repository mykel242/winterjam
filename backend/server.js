// server.js
const express = require("express");
const routes = require("./routes");
const PORT = process.env.PORT || 3000;
const app = express();

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Allow JSON request bodies
app.use(express.json());

// Mount all routes
app.use("/", routes);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
