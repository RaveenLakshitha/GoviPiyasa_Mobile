const Architect = require("../../models/Architects/architect");
const Awards = require("../../models/Architects/awards&pubs");

//const Item = require("../models/item");
//const shop = require("../models/shop");

//@desc     Get all awards
//@route    Get /api/v1/awards
//@access   Public
exports.getAwards = async (req, res, next) => {
  try {
    const awards = await Awards.find()
      .populate("architectId")
      .populate("userId");
    res.status(200).json({ success: true, count: awards.length, data: awards });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a Award
//@route    Get /api/v1/awards/:id
//@access   Public
exports.getAward = (req, res, next) => {};

//@desc     Create a Award
//@route    Post /api/v1/awards
//@access   Public
exports.createAward = async (req, res, next) => {
  let gallery = [];

  if (req.files.length > 0) {
    gallery = req.files.map((file) => {
      return { img: file.filename };
    });
  }
  req.body.gallery = gallery;

  // req.body.createdBy = req.user.id;
  req.body.architectId = req.architect.id;
  req.body.userId = req.architect.user;

  const award = await Award.create(req.body);
  await Architect.findOneAndUpdate(
    { user: req.architect.user },
    {
      $push: {
        awards: award.id,
      },
    }
  );

  res.status(201).json({ success: true, data: award });
};
//@desc     Update a award
//@route    Put /api/v1/awards
//@access   Public
exports.updateAward = (req, res, next) => {
  try {
    const award = await Award.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!award) {
      return next(
        new ErrorResponse(`award not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: award });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a award
//@route    Delete /api/v1/awards
//@access   Private
exports.deleteAward = (req, res, next) => {
  try {
    const award = await AWard.findByIdAndDelete(req.params.id);

    if (!award) {
      return next(
        new ErrorResponse(`Award not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
