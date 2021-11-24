const express = require("express");
const {
  getItems,
  getItem,
  createItem,
  updateItem,
  deleteItem,
} = require("../controllers/item");
const { protect } = require("../middleware/auth");
const { accessShop } = require("../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");

const router = express.Router();

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(path.dirname(__dirname), "uploads/items"));
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

router
  .route("/")
  .get(getItems)
  .post(accessShop, upload.array("productPicture"), createItem);
router.route("/:id").get(getItem).put(updateItem).delete(deleteItem);

module.exports = router;
