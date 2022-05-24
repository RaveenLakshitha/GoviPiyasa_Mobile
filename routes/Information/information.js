const express = require("express");
const {
  getAllInfo,
  getInfo,
  createInfo,
  updateInfo,
  deleteInfo,
} = require("../../controllers/Information/information");

const router = express.Router();
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(path.dirname(__dirname), "uploads/Informations"));
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});
const upload = multer({ storage });
router.route("/").get(getAllInfo).post(upload.single("Image"), createInfo);
router.route("/:id").get(getInfo).put(updateInfo).delete(deleteInfo);

module.exports = router;
