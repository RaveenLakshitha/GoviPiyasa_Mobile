const Architect = require("../../models/Architects/architect");
const Project = require("../../models/Architects/projects");

//const Item = require("../models/item");
//const shop = require("../models/shop");

//@desc     Get all projects
//@route    Get /api/v1/projects
//@access   Public
exports.getProjects = async (req, res, next) => {
  try {
    const projects = await Project.find()
      .populate("architectId")
      .populate("userId");
    res
      .status(200)
      .json({ success: true, count: projects.length, data: projects });
  } catch (err) {
    next(err);
  }
};
//@desc     Get a Project
//@route    Get /api/v1/projects/:id
//@access   Public
exports.getProject = (req, res, next) => {};

//@desc     Create a Project
//@route    Post /api/v1/projects
//@access   Public
exports.createProject = async (req, res, next) => {
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

  const project = await Project.create(req.body);
  await Architect.findOneAndUpdate(
    { user: req.architect.user },
    {
      $push: {
        projects: project.id,
      },
    }
  );

  res.status(201).json({ success: true, data: project });
};
//@desc     Update a project
//@route    Put /api/v1/projects
//@access   Public
exports.updateProject = (req, res, next) => {
  try {
    const project = await Project.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!project) {
      return next(
        new ErrorResponse(`project not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: project });
  } catch (err) {
    next(err);
  }
};
//@desc     Delete a project
//@route    Delete /api/v1/projects
//@access   Private
exports.deleteProject = (req, res, next) => {
  try {
    const project = await Project.findByIdAndDelete(req.params.id);

    if (!project) {
      return next(
        new ErrorResponse(`Project not Found With id of ${req.params.id}`, 404)
      );
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
