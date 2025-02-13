const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.send("Running => Node.js / express.js\n\n");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
