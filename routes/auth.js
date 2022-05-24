const express = require("express");
const {
  createUser,
  loginUser,
  getMe,
  getUsers,
  signoutUser,
  getSingleUser,
  getImage,
  updateProfilePic,
  updateUser,
  deleteUser,
} = require("../controllers/auth");

const router = express.Router();
const { protect } = require("../middleware/auth");

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

/* const storage = new GridFsStorage({
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
const upload = multer({ storage }); */
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(path.dirname(__dirname), "uploads/users"));
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

router.route("/register").post(upload.single("profilePicture"), createUser);
router.route("/login").post(loginUser);
router.route("/getLoggedUser").get(protect, getMe);
router.route("/getUsers").get(getUsers);
router.route("/signoutUser").get(signoutUser);
router.route("/checkusername/:firstName").get(getSingleUser);
router.route("/getImage/:filename").get(getImage);
router
  .route("/updateProfilePic/:id")
  .put(upload.single("profilePicture"), updateProfilePic);
router.route("/:id").put(updateUser);
router.route("/:id").put(deleteUser);
//router.route("/checkusername/:id").get(getSingleUser);

module.exports = router;
