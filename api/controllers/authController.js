const { check, validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const db = require("@models");
const User = db.User;

exports.login = async (req, res, next) => {
  try {
    // バリデーションエラーのチェック
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        errors: errors.array().map((err) => ({
          message: err.msg,
        })),
      });
    }

    const { email, password } = req.body;
    console.log("Login attempt for email:", email); // デバッグログ

    const user = await User.findOne({ where: { email } });
    console.log("Found user:", user?.toJSON()); // デバッグログ

    if (!user) {
      return res.status(401).json({
        message: "メールアドレスまたはパスワードが正しくありません",
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    console.log("Password match:", isMatch); // デバッグログ

    if (!isMatch) {
      return res.status(401).json({
        message: "メールアドレスまたはパスワードが正しくありません",
      });
    }

    const payload = {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    };
    console.log("Generated payload:", payload); // デバッグログ

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: "24h",
    });

    // レスポンスを明示的に構築
    const response = {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    };
    console.log("Sending response:", response); // デバッグログ

    return res.status(200).json(response);
  } catch (error) {
    console.error("Login error:", error);
    return res.status(500).json({ message: "サーバーエラーが発生しました" });
  }
};

exports.refreshToken = async (req, res, next) => {
  const { token } = req.body;

  if (!token) return res.status(401).json({ message: "No token provided" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const newToken = jwt.sign(
      { userId: decoded.userId },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      }
    );

    res.json({ token: newToken });
  } catch (err) {
    console.error("Token refresh failed:", err);
    return res.status(403).json({ message: "Invalid token" });
  }
};

exports.register = async (req, res, next) => {
  try {
    // バリデーションエラーのチェック
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        errors: errors.array().map((err) => ({
          message: err.msg,
        })),
      });
    }

    const { name, email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({ name, email, password: hashedPassword });
    const token = jwt.sign(
      { userId: user.id, name: user.name, email: user.email },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      }
    );
    res.status(200).json({
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "User registration failed." });
  }
};
