const express = require("express");
const {
  getArchitectProfiles,
  getArchitectProfile,
  createArchitectProfile,
  updateArchitectProfile,
  deleteArchitectProfile,
} = require("../controllers/user");

const router = express.Router();

router.route("/").get(getArchitectProfiles).post(createArchitectProfile);
router
  .route("/:id")
  .get(getArchitectProfile)
  .put(updateArchitectProfile)
  .delete(deleteArchitectProfile);

module.exports = router;
