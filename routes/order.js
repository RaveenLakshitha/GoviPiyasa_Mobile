const express = require("express");
const {
  getOrders,
  addOrderToShop,
  getOrder,
  createOrder,
  updateOrder,
  deleteOrder,
} = require("../controllers/orders");

const router = express.Router();

router.route("/").get(getOrders).post(addOrderToShop);
//router.route("/:id").get(getOrder).put(updateOrder).delete(deleteOrder);

module.exports = router;
