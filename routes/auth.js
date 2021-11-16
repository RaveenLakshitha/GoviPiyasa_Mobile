const express = require("express");
const {
  createUser,
  loginUser,
  getMe,
  getUsers,
  signoutUser,
} = require("../controllers/auth");

const router = express.Router();
const { protect } = require("../middleware/auth");

router.route("/register").post(createUser);
router.route("/login").post(loginUser);
router.route("/getLoggedUser").get(protect, getMe);
router.route("/getUsers").get(getUsers);
router.route("/signoutUser").get(signoutUser);

module.exports = router;
