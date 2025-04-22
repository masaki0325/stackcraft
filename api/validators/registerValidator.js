const { check } = require("express-validator");

exports.registerValidator = [
  check("name").not().isEmpty().withMessage("名前は必須です").trim(),

  check("email")
    .isEmail()
    .withMessage("有効なメールアドレスを入力してください")
    .normalizeEmail(),

  check("password")
    .isLength({ min: 6 })
    .withMessage("パスワードは6文字以上である必要があります")
    .trim(),
];
