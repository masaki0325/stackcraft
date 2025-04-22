const express = require("express");
const router = express.Router();
const authController = require("@controllers/authController");
const { loginValidator } = require("@validators/authValidator");
const { registerValidator } = require("@validators/registerValidator");

// ログインルート
router.post("/login", loginValidator, authController.login);

// 新規登録ルート
router.post("/register", registerValidator, authController.register);

// トークン更新ルート
router.post("/refresh", authController.refreshToken);

module.exports = router;
