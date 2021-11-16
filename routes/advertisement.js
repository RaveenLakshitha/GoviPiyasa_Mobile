const express = require("express");
const {
  getAdds,
  getAdd,
  createAdd,
  updateAdd,
  deleteAdd,
} = require("../controllers/advertisements");

const router = express.Router();

router.route("/").get(getAdds).post(createAdd);
router.route("/:id").get(getAdd).put(updateAdd).delete(deleteAdd);

module.exports = router;
