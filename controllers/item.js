const Item = require("../models/item");

//@desc     Get all items
//@route    Get /api/v1/items
//@access   Public
exports.getItems = async (req, res, next) => {
  try {
    const items = await Item.find().populate("shopId");
    res.status(200).json({ success: true, count: items.length, data: items });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a item
//@route    Get /api/v1/items/:id
//@access   Public
exports.getItem = (req, res, next) => {};

//@desc     Create a item
//@route    Post /api/v1/items
//@access   Public
exports.createItem = async (req, res, next) => {
  let productPictures = [];

  if (req.files.length > 0) {
    productPictures = req.files.map((file) => {
      return { img: file.filename };
    });
  }
  req.body.productPictures = productPictures;

  // req.body.createdBy = req.user.id;
  req.body.shopId = req.shop.id;
  const item = await Item.create(req.body);
  res.status(201).json({ success: true, data: item });
};
//@desc     Update a item
//@route    Put /api/v1/items
//@access   Public
exports.updateItem = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Update item ${req.params.id}` });
};
//@desc     Delete a item
//@route    Delete /api/v1/items
//@access   Private
exports.deleteItem = (req, res, next) => {
  res.status(200).json({ success: true, msg: `Delete item ${req.params.id}` });
};
