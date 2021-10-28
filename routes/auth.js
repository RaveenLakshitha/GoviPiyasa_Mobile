const express = require("express");
const {
  createUser,
  loginUser,
  getMe,
  getUsers,
} = require("../controllers/auth");

const router = express.Router();

router.route("/register").post(createUser);
router.route("/login").post(loginUser);
router.route("/getUser").get(getMe);
router.route("/getUsers").get(getUsers);

module.exports = router;
