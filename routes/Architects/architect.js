const express = require("express");
const { protect } = require("../../middleware/auth");
const { accessShop } = require("../../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");
const Grid = require("gridfs-stream");
var mongo = require("mongodb");
const crypto = require("crypto");
const { GridFsStorage } = require("multer-gridfs-storage");
const mongoose = require("mongoose");
const mongodb = require("mongodb");
const conn = mongoose.connection;
const fs = require("fs");
const {
  getArchitects,
  getUsersArchitectProfile,
  createArchitect,
  updateArchitect,
  deleteArchitect,
  getFiles,
  getImage,
  updateLogo,
  getSingleArchitect,
} = require("../../controllers/Architects/architect");

const router = express.Router();
/* let gfs;

conn.once("open", () => {
  (gfs = new mongoose.mongo.GridFSBucket(conn.db)),
    {
      bucketName: "images",
    };
}); */
//Create storage engine

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
////////////////////////////////////////////////////////////

/*const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(
      null,
      path.join(path.dirname(__dirname), "../uploads/Architects/Profile")
    );
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});
const upload = multer({ storage });
*/
router.route("/files").get(getFiles);
//router.route("/file").get(getFile);
router.route("/getImage/:filename").get(getImage);

router.route("/uploadImage").post(upload.single("logo"));
router
  .route("/")
  .get(getArchitects)
  .post(protect, upload.single("logo"), createArchitect);
//.post(protect, createArchitect);
router
  .route("/getUsersArchitectProfile")
  .get(protect, getUsersArchitectProfile);
router
  .route("/:id")
  .get(getSingleArchitect)
  .put(upload.single("logo"), updateArchitect)
  .delete(deleteArchitect);
router.route("/updateLogo/:id").put(upload.single("logo"), updateLogo);
//router.route("/:filename").get(getFile);

module.exports = router;
