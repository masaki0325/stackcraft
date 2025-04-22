const bcrypt = require("bcryptjs");

(async () => {
  const plainPassword = "password";
  const hash = await bcrypt.hash(plainPassword, 10);
  console.log("ハッシュ化されたパスワード:", hash);
})();
