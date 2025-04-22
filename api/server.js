require("module-alias/register");
const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
dotenv.config();

const app = express();

const db = require("@models");

// すべてのオリジンからのアクセスを許可
app.use(cors());

app.use(express.json());

app.use("/api/users", require("./routes/user"));
app.use("/api/notes", require("./routes/note"));
app.use("/api/auth", require("./routes/auth"));

db.sequelize
  .authenticate()
  .then(() => console.log("✅ DB Connected!"))
  .catch((err) => console.error("❌ DB Connection Failed:", err));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
