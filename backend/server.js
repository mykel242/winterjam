// server.js
const express = require("express");
const routes = require("./routes");
const app = express();
const PORT = process.env.PORT || 3000;

// Allow JSON request bodies
app.use(express.json());

// Mount all routes
app.use("/", routes);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
