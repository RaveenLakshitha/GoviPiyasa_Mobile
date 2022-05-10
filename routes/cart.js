const express = require("express");
const { addItemToCart } = require("../controllers/cart");

const router = express.Router();
const { protect } = require("../middleware/auth");

router.route("/").post(protect, addItemToCart);

module.exports = router;
