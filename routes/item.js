const express = require("express");
const {
  getItems,
  getItem,
  createItem,
  updateItem,
  deleteItem,
  getImage,
} = require("../controllers/item");
const { protect } = require("../middleware/auth");
const { accessShop } = require("../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");

const router = express.Router();

const Grid = require("gridfs-stream");
var mongo = require("mongodb");
const crypto = require("crypto");
const { GridFsStorage } = require("multer-gridfs-storage");
const mongoose = require("mongoose");
const mongodb = require("mongodb");
const conn = mongoose.connection;
const fs = require("fs");

const storage = new GridFsStorage({
  url: "mongodb+srv://Raveen_lw_learn:Raveen@govipiyasav1.8foh6.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",
  file: (req, file) => {
    return new Promise((resolve, reject) => {
      crypto.randomBytes(16, (err, buf) => {
        if (err) {
          return reject(err);
        }
        const filename = buf.toString("hex") + path.extname(file.originalname);
        const fileInfo = {
          filename: shortid.generate() + "-" + file.originalname,
          bucketName: "fs",
        };
        resolve(fileInfo);
      });
    });
  },
});
const upload = multer({ storage });

/* const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(path.dirname(__dirname), "uploads/items"));
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});

const upload = multer({ storage }); */

router
  .route("/")
  .get(getItems)
  .post(accessShop, upload.array("productPicture"), createItem);
router.route("/:id").get(getItem).put(updateItem).delete(deleteItem);
router.route("/getImage/:filename").get(getImage);

module.exports = router;
