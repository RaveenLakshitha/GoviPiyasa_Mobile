const category = require("../models/category");
const Item = require("../models/item");
const shop = require("../models/shop");

const ErrorResponse = require("../utils/errorResponse");
const mongoose = require("mongoose");
const conn = mongoose.connection;

const url =
  "mongodb+srv://Raveen_lw_learn:Raveen@govipiyasav1.8foh6.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";
let gfs;
/* 
conn.once("open", () => {
  gfs = Grid(conn.db, mongoose.mongo);
  gfs.collection("uploads");
}); */
conn.once("open", () => {
  gfs = new mongoose.mongo.GridFSBucket(conn.db);
});

//@desc     Get all items
//@route    Get /api/v1/items
//@access   Public
exports.getItems = async (req, res, next) => {
  try {
    const items = await Item.find().populate("shopId").populate("userId");
    res.status(200).json({ success: true, count: items.length, data: items });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a item
//@route    Get /api/v1/items/:id
//@access   Public

exports.getItem = async (req, res, next) => {
  try {
    const item = await Item.findById(req.params.id);

    if (!item) {
      return next(
        new ErrorResponse(`Item not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: item });
  } catch (err) {
    next(err);
  }
};

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
  req.body.userId = req.shop.user;

  const item = await Item.create(req.body);
  await shop.findOneAndUpdate(
    { user: req.shop.user },
    {
      $push: {
        shopItems: item.id,
      },
    }
  );
  await category.findOneAndUpdate(
    { categoryName: req.body.categoryName },
    {
      $push: {
        Items: item.id,
      },
    }
  );
  res.status(201).json({ success: true, data: item });
};
//@desc     Update a item
//@route    Put /api/v1/items
//@access   Public
exports.updateItem = async (req, res, next) => {
  try {
    const item = await Item.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!item) {
      return next(
        new ErrorResponse(`Item not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: item });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a item
//@route    Delete /api/v1/items
//@access   Private
exports.deleteItem = async (req, res, next) => {
  try {
    const item = await Item.findByIdAndDelete(req.params.id);

    if (!item) {
      return next(
        new ErrorResponse(`Item not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};

//@desc     Get all Files
//@route    Get /api/v1/files
//@access   Public
exports.getImage = async (req, res, next) => {
  try {
    const filename = req.params.filename;
    gfs.find({ filename: filename.trim() }).toArray((err, files) => {
      gfs.openDownloadStreamByName(req.params.filename).pipe(res);
    });

    /* const _id = req.params.id;
    gfs.find({ _id }).toArray((err, files) => {
      gfs.openDownloadStream(_id).pipe(res);
    }); */
    /* gfs.find().toArray((err, files) => {
      res.status(200).json({ success: true, data: files });
    }); */
  } catch (err) {
    next(err);
  }
};
