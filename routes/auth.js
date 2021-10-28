const express = require("express");
const { createUser, loginUser, getMe } = require("../controllers/auth");

const router = express.Router();

router.route("/register").post(createUser);
router.route("/login").post(loginUser);
router.route("/getUser").get(getMe);

module.exports = router;
