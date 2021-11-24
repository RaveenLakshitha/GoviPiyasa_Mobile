/* const express = require("express");
const {
  getPubs,
  getPub,
  createPub,
  updatePub,
  deletePub,
} = require("../../controllers/Architects/awards&pubs");
const { protect } = require("../../middleware/auth");
const { accessShop } = require("../../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");

const router = express.Router();

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(
      null,
      path.join(
        path.dirname(__dirname),
        "uploads/Architects/AwardsAndPublications"
      )
    );
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

router
  .route("/")
  .get(getPubs)
  .post(accessShop, upload.array("productPicture"), createPub);
router.route("/:id").get(getPub).put(updatePub).delete(deletePub);

module.exports = router;
 */
