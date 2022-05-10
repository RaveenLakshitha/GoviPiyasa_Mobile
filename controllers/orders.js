const { findByIdAndUpdate } = require("../models/order");
const Order = require("../models/order");
const shop = require("../models/shop");
//@desc     Remove item from Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.getOrders = async (req, res, next) => {
  try {
    const orders = await Order.find();

    res.status(200).json({ success: true, count: orders.length, data: orders });
  } catch (err) {
    next(err);
  }
};
//@desc     Add Item to Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.addOrderToShop = async (req, res, next) => {
  /*
  paidCartItems[Item]->shopId-->shop-[OrederedItems++]
  */
  try {
    const order = await Order.create(req.body);
    await shop.findOneAndUpdate(
      { id: req.body.shopId },
      {
        $push: {
          orders: order.id,
        },
      }
    );
    return res.status(200).json({ success: true, data: order });
    //[Order model should update with cart Items when click the Place Order button]-->Enter bank Card-->Pass By PayCheck-->Place Order-->Change Payment Status
  } catch (err) {
    next(err);
  }
};
//@desc     Add Item to Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.ChangeShopOrderStatus = async (req, res, next) => {
  try {
    const newState = Order.findByIdAndUpdate(req.body.id, req.body.newStatus);

    return res.status(200).json({ success: true, data: newState });
  } catch (err) {
    next(err);
  }
};
//@desc     Remove item from Cart
//@route    Post /api/v1/Categories
//@access   Public
exports.removeOrder = async (req, res, next) => {
  try {
    const cart = new Cart({
      user: req.user.id,
      cartItems: req.body.cartItems,
    });

    cart.save((cart) => {
      if (cart) {
        return res.status(200).json({ success: true, data: cart });
      }
    });
  } catch (err) {
    next(err);
  }
};
