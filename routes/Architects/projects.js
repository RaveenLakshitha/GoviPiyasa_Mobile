const express = require("express");
const {
  getProjects,
  getProject,
  createProject,
  updateProject,
  deleteProject,
} = require("../../controllers/Architects/projects");
//const { protect } = require("../middleware/auth");
const { accessShop } = require("../../middleware/shopAuth");
const multer = require("multer");
const path = require("path");
const shortid = require("shortid");

const router = express.Router();

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(path.dirname(__dirname), "uploads/Architects/Projects"));
  },
  filename: function (req, file, cb) {
    cb(null, shortid.generate() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

router
  .route("/")
  .get(getProjects)
  .post(accessShop, upload.array("productPicture"), createProject);
router.route("/:id").get(getProject).put(updateProject).delete(deleteProject);

module.exports = router;
