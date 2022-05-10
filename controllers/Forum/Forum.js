const Forum = require("../../models/Forum/Forum");
const user = require("../../models/user");
exports.getQuestions = async (req, res, next) => {
  try {
    const Questions = await Forum.find();
    res
      .status(200)
      .json({ success: true, count: Questions.length, data: Questions });
  } catch (err) {
    next(err);
  }
};
exports.getUsersQuestions = async (req, res, next) => {
  try {
    const Questions = await Forum.find();
    res
      .status(200)
      .json({ success: true, count: Questions.length, data: Questions });
  } catch (err) {
    next(err);
  }
};

exports.AddQuestion = async (req, res, next) => {
  try {
    req.body.user = req.user.id;

    const Question = await Forum.create(req.body);
    await user.findOneAndUpdate(
      { user: req.body.user },
      {
        $push: {
          questLiked: Question.id,
        },
      }
    );
    res.status(200).json({ success: true, data: Question });
  } catch (err) {
    next(err);
  }
};
exports.AddAnswer = async (req, res, next) => {
  req.body.UserId = req.user.id;
  const ans = await Forum.findOneAndUpdate(
    { _id: req.body.QuestionId },
    {
      $push: {
        Answer: req.body,
      },
    }
  );
  res.status(200).json({ success: true, data: ans });
};
exports.AddVoteToQuest = async (req, res, next) => {
  try {
    req.body.UserId = req.user.id;
    const ans = await Forum.updateOne(
      { _id: req.body.QuestionId, "Answer._id": req.body.AnswerId },
      { $inc: { "Answer.$.AnswerVote": 1 } }
      //Add voted Q or A ID into user profile
    );

    await user.findOneAndUpdate(
      { user: req.body.user },
      {
        $push: {
          ansLiked: req.body.AnswerId,
        },
      }
    );

    res.status(200).json({ success: true, data: ans });
  } catch (err) {
    next(err);
  }
};
exports.DownVoteToQuest = async (req, res, next) => {
  try {
    req.body.UserId = req.user.id;
    const ans = await Forum.updateOne(
      { _id: req.body.QuestionId, "Answer._id": req.body.AnswerId },
      { $inc: { "Answer.$.AnswerVote": -1 } }
    );
    res.status(200).json({ success: true, data: ans });
  } catch (err) {
    next(err);
  }
};
exports.AddVoteToAnswer = async (req, res, next) => {
  try {
    req.body.UserId = req.user.id;
    const ans = await Forum.updateOne(
      { _id: req.body.QuestionId, "Answer._id": req.body.AnswerId },
      { $inc: { "Answer.$.AnswerVote": 1 } }
      //Add voted Q or A ID into user profile
    );

    await user.findOneAndUpdate(
      { user: req.body.user },
      {
        $push: {
          ansLiked: req.body.AnswerId,
        },
      }
    );

    res.status(200).json({ success: true, data: ans });
  } catch (err) {
    next(err);
  }
};
exports.DownVoteToAnswer = async (req, res, next) => {
  try {
    req.body.UserId = req.user.id;
    const ans = await Forum.updateOne(
      { _id: req.body.QuestionId, "Answer._id": req.body.AnswerId },
      { $inc: { "Answer.$.AnswerVote": -1 } }
    );
    res.status(200).json({ success: true, data: ans });
  } catch (err) {
    next(err);
  }
};
exports.RemoveQuestion = async (req, res, next) => {
  try {
  } catch (err) {
    next(err);
  }
};
exports.RemoveAnswer = async (req, res, next) => {
  try {
  } catch (err) {
    next(err);
  }
};
exports.UpdateQuestion = async (req, res, next) => {
  try {
  } catch (err) {
    next(err);
  }
};
exports.UpdateAnswer = async (req, res, next) => {
  try {
  } catch (err) {
    next(err);
  }
};
