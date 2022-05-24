//const asyncHandler = require("../middleware/async");
const item = require("../models/item");
const Shop = require("../models/shop");
const user = require("../models/user");
const ErrorResponse = require("../utils/errorResponse");

//@desc     Get all shops
//@route    Get /api/v1/shops
//@access   Public
exports.getShops = async (req, res, next) => {
  try {
    const shops = await Shop.find()
      .populate("user")
      .populate("shopItems")
      .populate("orders");

    res.status(200).json({ success: true, count: shops.length, data: shops });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a shop
//@route    Get /api/v1/shops/:id
//@access   Public
exports.getUsersShop = async (req, res, next) => {
  try {
    const shop = await Shop.findOne({ user: req.user.id }).populate(
      "shopItems"
    );
    console.log(shop.items);
    if (!shop) {
      return next(
        new ErrorResponse(`Shop not Found With id of ${req.user.id}`, 404)
      );
    }

    const shopToken = shop.getShopSignedJwtToken();
    res
      .status(200)
      // .json({ success: true, data: shop, items: shop.items, shopToken });
      .json({ success: true, data: shop, shopToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Create a shop
//@route    Post /api/v1/shops
//@access   Public
exports.createShop = async (req, res, next) => {
  try {
    //Add user to req.body
    req.body.user = req.user.id;
    console.log(req.user.id);

    //Check for published shop
    const createdShop = await Shop.findOne({ user: req.user.id });

    //Admin can add more shops
    if (createdShop && req.user.role !== "admin") {
      return next(
        new ErrorResponse(
          `The user with ID ${req.user.id} has already published a shop`,
          400
        )
      );
    }

    const shop = await Shop.create(req.body);
    console.log(shop);
    await user.findByIdAndUpdate(req.user.id, { shopId: shop.id });
    //Create Token
    const shopToken = shop.getShopSignedJwtToken();
    res.status(201).json({ success: true, data: shop, shopToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Update a shop
//@route    Put /api/v1/shops
//@access   Public
exports.updateShop = async (req, res, next) => {
  try {
    const shop = await Shop.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!shop) {
      return next(
        new ErrorResponse(`Shop not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: shop });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a shop
//@route    Delete /api/v1/shops
//@access   Private
exports.deleteShop = async (req, res, next) => {
  try {
    await user.findByIdAndUpdate(req.body.userId, { $set: { shopId: null } });
    const shop = await Shop.findByIdAndDelete(req.params.id);

    if (!shop) {
      return next(
        new ErrorResponse(`Shop not Found With id of ${req.params.id}`, 404)
      );
    }

    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};

/* 
//@desc     Get all shops
//@route    Get /api/v1/shops
//@access   Public
exports.getShops = asyncHandler( async (req, res, next) => {
    const shops = await Shop.find();
    res.status(200).json({ success: true, count: shops.length, data: shops });
  } 
); */
