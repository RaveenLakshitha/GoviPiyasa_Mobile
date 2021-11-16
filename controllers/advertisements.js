const advertisement = require("../models/advertisement");
const ErrorResponse = require("../utils/errorResponse");

//@desc     Get all adds
//@route    Get /api/v1/advertisements
//@access   Public
exports.getAdds = async (req, res, next) => {
  try {
    const adds = await advertisement.find();
    res.status(200).json({ success: true, count: adds.length, data: adds });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};
//@desc     Get a add
//@route    Get /api/v1/advertisements/:id
//@access   Public
exports.getAdd = async (req, res, next) => {
  try {
    const add = await advertisement.findById(req.params.id);

    if (!add) {
      next(
        new ErrorResponse(`User not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: add });
  } catch (err) {
    next(new ErrorResponse(`User not Found With id of ${req.params.id}`, 404));
  }
};
//@desc     Create a user
//@route    Post /api/v1/advertisements
//@access   Public
exports.createAdd = async (req, res, next) => {
  const add = await advertisement.create(req.body);
  res.status(201).json({ success: true, data: add });
};
//@desc     Update a user
//@route    Put /api/v1/advertisements/:id
//@access   Public
exports.updateAdd = async (req, res, next) => {
  try {
    const add = await advertisement.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!add) {
      return res.status(400).json({ success: false });
    }
    res.status(200).json({ success: true, data: add });
  } catch (err) {
    return res.status(400).json({ success: false });
  }
};
//@desc     Delete a user
//@route    Delete /api/v1/advertisements/:id
//@access   Private
exports.deleteAdd = async (req, res, next) => {
  try {
    const add = await advertisement.findByIdAndDelete(req.params.id);

    if (!add) {
      return res.status(400).json({ success: false });
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    return res.status(400).json({ success: false });
  }
};
