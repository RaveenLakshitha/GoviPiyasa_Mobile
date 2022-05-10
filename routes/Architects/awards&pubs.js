const express = require("express");
const {
  getAwards,
  getAward,
  createAward,
  updateAward,
  deleteAward,
} = require("../../controllers/Architects/awards&pubs");
const { protect } = require("../middleware/auth");
const { accessArchitect } = require("../../middleware/architectAuth");
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

router
  .route("/")
  .get(getAwards)
  .post(accessArchitect, upload.array("gallery"), createAward);
router.route("/:id").get(getAward).put(updateAward).delete(deleteAward);

module.exports = router;
