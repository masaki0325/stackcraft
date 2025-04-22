/**
 * 指定された役割（role）を持つユーザーのみアクセスを許可するミドルウェア
 * @param {string[]} allowedRoles - 許可する役割の配列
 * @returns {Function} Express middleware
 */
const checkRole = (allowedRoles) => {
  return (req, res, next) => {
    try {
      // authミドルウェアでデコードされたユーザー情報から役割を取得
      const userRole = req.user.role;
      console.log("userRole", userRole);

      if (!userRole || !allowedRoles.includes(userRole)) {
        return res.status(403).json({
          message: "この操作を実行する権限がありません",
        });
      }

      next();
    } catch (error) {
      console.error("Role check error:", error);
      res.status(500).json({
        message: "権限チェック中にエラーが発生しました",
      });
    }
  };
};

module.exports = checkRole;
