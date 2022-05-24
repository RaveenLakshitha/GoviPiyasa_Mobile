const Shop = require("../../models/shop");
const user = require("../../models/user");
const ErrorResponse = require("../../utils/errorResponse");
const Information = require("../../models/information");
//@desc     Get all shops
//@route    Get /api/v1/shops
//@access   Public
exports.getAllInfo = async (req, res, next) => {
  try {
    const Informations = await Information.find();
    res
      .status(200)
      .json({ success: true, count: Informations.length, data: Informations });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};
//@desc     Get a shop
//@route    Get /api/v1/shops/:id
//@access   Public
exports.getInfo = async (req, res, next) => {
  try {
    const Info = await advertisement.findById(req.params.id);
    if (!add) {
      next(new ErrorResponse(`Not Found With id of ${req.params.id}`, 404));
    }
    res.status(200).json({ success: true, data: Info });
  } catch (err) {
    next(new ErrorResponse(`Not Found With id of ${req.params.id}`, 404));
  }
};
//@desc     Create a shop
//@route    Post /api/v1/shops
//@access   Public
exports.createInfo = async (req, res, next) => {
  try {
    const Informations = await Information.create(req.body);
    res.status(200).json({ success: true, data: Informations });
  } catch (err) {
    next(new ErrorResponse(`Not Found With id of ${req.params.id}`, 404));
  }
};
//@desc     Update a shop
//@route    Put /api/v1/shops
//@access   Public
exports.updateInfo = async (req, res, next) => {
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
exports.deleteInfo = async (req, res, next) => {
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
