const express = require("express");
const {
  getShops,
  getShop,
  createShop,
  updateShop,
  deleteShop,
} = require("../controllers/shop");

const router = express.Router();
const { protect } = require("../middleware/auth");

router.route("/").get(getShops).post(protect, createShop);
router.route("/:id").get(getShop).put(updateShop).delete(deleteShop);

module.exports = router;
