const express = require("express");
const {
  getQuestions,
  getAnswers,
  AddQuestion,
  AddAnswer,
  AddVoteToAnswer,
  DownVoteToAnswer,
  RemoveQuestion,
  RemoveAnswer,
  UpdateQuestion,
  UpdateAnswer,
  getUsersQuestions,
} = require("../../controllers/Forum/Forum");

const router = express.Router();
const { protect } = require("../../middleware/auth");

router.route("/getQuestions").get(getQuestions);
router.route("/AddQuestion").post(protect, AddQuestion);
router.route("/addAnswer").post(protect, AddAnswer);
router.route("/RemoveQuestion").post(protect, RemoveQuestion);
router.route("/RemoveAnswer").post(protect, RemoveAnswer);
router.route("/AddVoteToAnswer").post(protect, AddVoteToAnswer);
router.route("/DownVoteToAnswer").put(protect, DownVoteToAnswer);
router.route("/getUsersShop").get(protect, getUsersQuestions);
router.route("/UpdateQuestion/:id").put(UpdateQuestion);
router.route("/UpdateAnswer/:id").put(UpdateAnswer);
router.route("/RemoveQuestion/:id").delete(RemoveQuestion);
router.route("/RemoveAnswer/:id").delete(RemoveAnswer);

module.exports = router;
