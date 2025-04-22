const { check } = require("express-validator");

exports.loginValidator = [
  check("email")
    .notEmpty()
    .withMessage("メールアドレスは必須です")
    .isEmail()
    .withMessage("有効なメールアドレスを入力してください"),
  check("password")
    .notEmpty()
    .withMessage("パスワードは必須です")
    .isLength({ min: 6 })
    .withMessage("パスワードは6文字以上で入力してください"),
];
