const jwt = require("jsonwebtoken");
const db = require("@models");
const User = db.User;

const auth = async (req, res, next) => {
  try {
    const authHeader = req.header("Authorization");
    if (!authHeader) {
      return res
        .status(401)
        .json({ message: "Authorization header is required" });
    }

    const token = authHeader.replace("Bearer ", "");
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const user = await User.findOne({ where: { id: decoded.user.id } });
    if (!user) {
      throw new Error();
    }

    console.log(user);

    req.token = token;
    req.user = user;
    next();
  } catch (error) {
    console.log(error);
    res.status(401).json({ message: "Please authenticate" });
  }
};

module.exports = auth;
