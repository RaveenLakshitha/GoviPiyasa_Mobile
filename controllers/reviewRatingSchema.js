const item = require("../models/item");
const reviews = require("../models/reviewRating");
const ErrorResponse = require("../utils/errorResponse");
//@desc     Get all reviews
//@route    Get /api/v1/reviews
//@access   Public
exports.getReviews = async (req, res, next) => {
  try {
    const reviews = await reviews.find({ item: req.params.item });

    res
      .status(200)
      .json({ success: true, count: reviews.length, data: reviews });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a order
//@route    Get /api/v1/orders/:id
//@access   Public
exports.getReview = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Show order ${req.params.id}` });
};
//@desc     Create a order
//@route    Post /api/v1/orders
//@access   Public
exports.createRewiew = async (req, res, next) => {
  try {
    //Add user to req.body
    req.body.user = req.user.id;
    console.log(req.user.id);

    //Check for published shop
    const createdReview = await reviews.findOne({ user: req.user.id });

    //Admin can add more shops
    if (createdReview && req.user.role !== "admin") {
      return next(
        new ErrorResponse(
          `The user with ID ${req.user.id} has already published a Review`,
          400
        )
      );
    }

    const review = await reviews.create(req.body);
    console.log(review);
    await user.findByIdAndUpdate(req.user.id, { shopId: shop.id });
    //Create Token
    const shopToken = shop.getShopSignedJwtToken();
    res.status(201).json({ success: true, data: shop, shopToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Update a orders
//@route    Put /api/v1/order
//@access   Public
exports.updateShop = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Update order ${req.params.id}` });
};
//@desc     Delete a order
//@route    Delete /api/v1/order
//@access   Private
exports.deleteShop = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Delete order ${req.params.id}` });
};
