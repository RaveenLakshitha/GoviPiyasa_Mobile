const express = require("express");
const { protect } = require("../../middleware/auth");
const { accessShop } = require("../../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");
const {
  getArchitects,
  getUsersArchitectProfile,

  createArchitect,
  updateArchitect,
  deleteArchitect,
} = require("../../controllers/Architects/architect");

const router = express.Router();

const storage = multer.diskStorage({
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

router
  .route("/")
  .get(getArchitects)
  .post(protect, upload.single("logo"), createArchitect);
router
  .route("/getUsersArchitectProfile")
  .get(protect, getUsersArchitectProfile);
router.route("/:id").put(updateArchitect).delete(deleteArchitect);

module.exports = router;
