const express = require("express");
const router = express.Router();
const auth = require("@middleware/auth");
const checkRole = require("@middleware/checkRole");
const userController = require("@controllers/userController");

router.get(
  "/",
  [auth, checkRole(["admin", "moderator"])],
  userController.getAllUsers
);

module.exports = router;
