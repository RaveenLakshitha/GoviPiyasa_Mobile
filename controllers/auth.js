const user = require("../models/user");
const ErrorResponse = require("../utils/errorResponse");

//@desc     Create a user
//@route    Post /api/v1/users
//@access   Public
exports.createUser = async (req, res, next) => {
  try {
    const User = await user.create(req.body);

    //Create Token
    const token = User.getSignedJwtToken();

    res.status(201).json({ success: true, data: User, token });
  } catch (err) {
    next(err);
  }
};
//@desc     Login User
//@route    Post /api/v1/users
//@access   Public
exports.loginUser = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    //Validate email and password
    if (!email || !password) {
      return next(
        new ErrorResponse("Please provide an email and password", 400)
      );
    }

    //Check for user
    const User = await user.findOne({ email }).select("+password");

    if (!user) {
      new ErrorResponse("Invalid Credintials", 401);
    }

    //Check if password matches
    const isMatch = await User.matchPassword(password);
    //Create Token
    const token = User.getSignedJwtToken();

    res.status(201).json({ success: true, token });
  } catch (err) {
    next(err);
  }
};

//@desc         Get Current Login user
//@route        Get /api/v1/auth/me
//@access       private

exports.getMe = async (req, res, next) => {
  const user = await User.findById(req.user.id);

  res.status(200).json({
    success: true,
    data: user,
  });
};

//@desc     Get all users
//@route    Get /api/v1/users
//@access   Public
exports.getUsers = async (req, res, next) => {
  try {
    const users = await User.find();
    res.status(200).json({ success: true, count: users.length, data: users });
  } catch (err) {
    next(err);
  }
};
