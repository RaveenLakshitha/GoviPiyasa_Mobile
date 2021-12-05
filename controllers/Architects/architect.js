//const asyncHandler = require("../middleware/async");
//const item = require("../../models/item");
const Architect = require("../../models/Architects/architect");
const user = require("../../models/user");
const ErrorResponse = require("../../utils/errorResponse");
const mongo = require("mongodb");
const multer = require("multer");
var Grid = require("gridfs-stream");
const crypto = require("crypto");
const GridFsStorage = require("multer-gridfs-storage");
const mongoose = require("mongoose");
const conn = mongoose.connection;
const mongodb = require("mongodb");
const fs = require("fs");
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

//@desc     Get all Architects
//@route    Get /api/v1/architects
//@access   Public
exports.getArchitects = async (req, res, next) => {
  try {
    const Architects = await Architect.find();

    res
      .status(200)
      .json({ success: true, count: Architects.length, data: Architects });
  } catch (err) {
    next(err);
  }
};
//@desc     Get all Files
//@route    Get /api/v1/files
//@access   Public
exports.getFiles = async (req, res, next) => {
  try {
    /* gfs.files.find().toArray((err, files) => {
      res.status(200).json({ success: true, data: files });
    }); */
    bucket.find().toArray((err, files) => {
      res.status(200).json({ success: true, data: files });
    });
  } catch (err) {
    next(err);
  }
};
//@desc     Get all Files
//@route    Get /api/v1/files
//@access   Public
exports.getImage = async (req, res, next) => {
  try {
    gfs.find({ filename: req.params.filename }).toArray((err, files) => {
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
/* //@desc     Get a File
//@route    Get /api/v1/file
//@access   Public
exports.getFile = async (req, res, next) => {
  try {
    /* const file = await gfs.files.findOne({ filename: req.params.filename });

    const readStream = await gfs.createReadStream(file.filename);
    readStream.pipe(res);
    //res.status(200).json({ success: true, data: file }); 
    mongodb.MongoClient.connect(url, function (error, client) {
      const db = client.db("myFirstDatabase");
      const bucket = new mongodb.GridFSBucket(db);
      const uploadStream = bucket.openUploadStream("bigBUck");
      const readStream = fs.createReadStream(req.file);
      readStream.pipe(uploadStream);
      res.status(200).json({ success: true });
    });
  } catch (err) {
    next(err);
  }
}; */
/* //@desc     Get a File
//@route    Get /api/v1/file
//@access   Public
exports.getImage = async (req, res, next) => {
  try {
    /* const file = await gfs.files.findOne({ filename: req.params.filename });

    const readStream = await gfs.createReadStream(file.filename);
    readStream.pipe(res);
    //res.status(200).json({ success: true, data: file }); 
    mongodb.MongoClient.connect(url, function (error, client) {
      const db = client.db("myFirstDatabase");
      /* db.collection("fs.files").findOne({}, (err, file) => {
        const bucket = new mongodb.openDownloadStreamByName();
        downloadStream.pipe(res);
      }); */
/* db.collection("fs.files")
        .find()
        .toArray((err, files) => {
          res.status(200).json({ success: true, data: files });
        }); 

      const bucket = new mongodb.GridFSBucket(db);
      bucket
        .openDownloadStreamByName("bigBUck")
        .pipe(res)
        .on("finish", () => {
          console.log("done downloading!");
          client.close();
        });
    });
  } catch (err) {
    next(err);
  }
}; */
//@desc     Get a shop
//@route    Get /api/v1/shops/:id
//@access   Public
exports.getUsersArchitectProfile = async (req, res, next) => {
  try {
    const architect = await Architect.findOne({ user: req.user.id });
    console.log(architect.items);
    if (!architect) {
      return next(
        new ErrorResponse(`Shop not Found With id of ${req.user.id}`, 404)
      );
    }

    const architectToken = architect.getArchitectSignedJwtToken();
    res
      .status(200)
      //.json({ success: true, data: shop, items: shop.items, shopToken });
      .json({ success: true, data: architect, architectToken });
  } catch (err) {
    next(err);
  }
};
//@desc     Create a shop
//@route    Post /api/v1/shops
//@access   Public
exports.createArchitect = async (req, res, next) => {
  try {
    //Add user to req.body
    req.body.user = req.user.id;
    console.log(req.user.id);

    //Check for published shop
    const createdArchitectProfile = await Architect.findOne({
      user: req.user.id,
    });

    //Admin can add more shops
    if (createdArchitectProfile && req.user.role !== "admin") {
      return next(
        new ErrorResponse(
          `The user with ID ${req.user.id} has already published a shop`,
          400
        )
      );
    }

    console.log(req.file.filename);
    req.body.logo = req.file.filename;
    const architect = await Architect.create(req.body);
    console.log(architect);
    await user.findByIdAndUpdate(req.user.id, { architectId: architect.id });
    //Create Token
    const architectToken = architect.getArchitectSignedJwtToken();
    res
      .status(201)
      .json({ success: true, data: architect, architectToken, file: req.file });
  } catch (err) {
    next(err);
  }
};
//@desc     Update a shop
//@route    Put /api/v1/shops
//@access   Public
exports.updateArchitect = async (req, res, next) => {
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
exports.deleteArchitect = async (req, res, next) => {
  try {
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
