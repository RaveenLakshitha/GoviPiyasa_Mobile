const express = require("express");
const {
  getShops,
  getShop,
  createShop,
  updateShop,
  deleteShop,
  getUsersShop,
} = require("../controllers/shop");

const router = express.Router();
const { protect } = require("../middleware/auth");

router.route("/").get(getShops).post(protect, createShop);
router.route("/getUsersShop").get(protect, getUsersShop);
router.route("/:id").put(updateShop).delete(deleteShop);

module.exports = router;
