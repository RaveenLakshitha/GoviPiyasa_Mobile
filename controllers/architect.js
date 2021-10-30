//const asyncHandler = require("../middleware/async");
const Architect = require("../models/ArchitectProfile");
const ErrorResponse = require("../utils/errorResponse");

//@desc     Get all ArchitectProfiles
//@route    Get /api/v1/ArchitectProfiles
//@access   Public
exports.getArchitectProfiles = async (req, res, next) => {
  try {
    const ArchitectProfiles = await Architect.find();
    res
      .status(200)
      .json({
        success: true,
        count: ArchitectProfiles.length,
        data: ArchitectProfiles,
      });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a ArchitectProfile
//@route    Get /api/v1/ArchitectProfile/:id
//@access   Public
exports.getArchitectProfile = async (req, res, next) => {
  try {
    const ArchitectProfile = await Architect.findById(req.params.id);

    if (!ArchitectProfile) {
      return next(
        new ErrorResponse(
          `ArchitectProfile not Found With id of ${req.params.id}`,
          404
        )
      );
    }
    res.status(200).json({ success: true, data: ArchitectProfile });
  } catch (err) {
    next(err);
  }
};
//@desc     Create a ArchitectProfile
//@route    Post /api/v1/ArchitectProfiles
//@access   Public
exports.createArchitectProfile = async (req, res, next) => {
  try {
    const ArchitectProfile = await Architect.create(req.body);
    res.status(201).json({ success: true, data: ArchitectProfile });
  } catch (err) {
    next(err);
  }
};
//@desc     Update a ArchitectProfile
//@route    Put /api/v1/ArchitectProfiles
//@access   Public
exports.updateArchitectProfile = async (req, res, next) => {
  try {
    const ArchitectProfile = await Architect.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true,
      }
    );

    if (!ArchitectProfile) {
      return next(
        new ErrorResponse(
          `ArchitectProfile not Found With id of ${req.params.id}`,
          404
        )
      );
    }
    res.status(200).json({ success: true, data: ArchitectProfile });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a ArchitectProfile
//@route    Delete /api/v1/ArchitectProfiles
//@access   Private
exports.deleteArchitectProfile = async (req, res, next) => {
  try {
    const ArchitectProfile = await Architect.findByIdAndDelete(req.params.id);

    if (!ArchitectProfile) {
      return next(
        new ErrorResponse(
          `ArchitectProfile not Found With id of ${req.params.id}`,
          404
        )
      );
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};

/* 
//@desc     Get all ArchitectProfiles
//@route    Get /api/v1/ArchitectProfiles
//@access   Public
exports.getArchitectProfiles = asyncHandler( async (req, res, next) => {
    const ArchitectProfiles = await Architect.find();
    res.status(200).json({ success: true, count: ArchitectProfiles.length, data: ArchitectProfiles });
  } 
); */
