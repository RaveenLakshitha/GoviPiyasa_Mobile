//const asyncHandler = require("../middleware/async");

const Architect = require("../models/architect");
const user = require("../models/user");
const ErrorResponse = require("../utils/errorResponse");

//@desc     Get all shops
//@route    Get /api/v1/shops
//@access   Public
exports.getArchitectProfiles = async (req, res, next) => {
  try {
    const architects = await Architect.find().populate("user");

    res
      .status(200)
      .json({ success: true, count: architects.length, data: architects });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a shop
//@route    Get /api/v1/shops/:id
//@access   Public
exports.getUsersArchitectProfiles = async (req, res, next) => {
  try {
    const architect = await Architect.findOne({ user: req.user.id });

    if (!architect) {
      return next(
        new ErrorResponse(
          `Architect Profile not Found With id of ${req.user.id}`,
          404
        )
      );
    }
    const architectToken = architect.getShopSignedJwtToken();
    res.status(200).json({ success: true, data: architect, architectToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Create a shop
//@route    Post /api/v1/shops
//@access   Public
exports.createArchitectProfile = async (req, res, next) => {
  try {
    //Add user to req.body
    req.body.user = req.user.id;
    console.log(req.user.id);

    //Check for published shop
    const createdArchitect = await Architect.findOne({ user: req.user.id });

    //Admin can add more shops
    if (createdArchitect && req.user.role !== "admin") {
      return next(
        new ErrorResponse(
          `The user with ID ${req.user.id} has already published a Architect Profile`,
          400
        )
      );
    }

    const architect = await Architect.create(req.body);
    console.log(architect);
    await user.findByIdAndUpdate(req.user.id, { architectId: architect.id });
    //Create Token
    const architectToken = architect.getShopSignedJwtToken();
    res.status(201).json({ success: true, data: architect, architectToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Update a shop
//@route    Put /api/v1/shops
//@access   Public
exports.updateArchitectProfile = async (req, res, next) => {
  try {
    const architect = await Shop.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!architect) {
      return next(
        new ErrorResponse(
          `Architect Profile not Found With id of ${req.params.id}`,
          404
        )
      );
    }
    res.status(200).json({ success: true, data: architect });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a shop
//@route    Delete /api/v1/shops
//@access   Private
exports.deleteArchitectProfile = async (req, res, next) => {
  try {
    const architect = await Architect.findByIdAndDelete(req.params.id);

    if (!architect) {
      return next(
        new ErrorResponse(
          `Architect Profile not Found With id of ${req.params.id}`,
          404
        )
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
