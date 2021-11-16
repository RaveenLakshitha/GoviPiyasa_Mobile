const user = require("../models/user");
const ErrorResponse = require("../utils/errorResponse");
const asyncHandler = require("../middleware/async");

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
        new ErrorResponse("Please provide an email and password", 401)
      );
    }

    //Check for user
    const User = await user.findOne({ email }).select("+password");

    if (!User) {
      return next(new ErrorResponse("Invalid Email", 401));
    }

    //Check if password matches
    const isMatch = await User.matchPassword(password);

    if (!isMatch) {
      return next(new ErrorResponse("Invalid Credintials", 401));
    }

    sendTokenResponse(User, 200, res);
  } catch (err) {
    next(err);
  }
};

//@desc         Get Current Login user
//@route        Get /api/v1/auth/me
//@access       private

exports.getMe = async (req, res, next) => {
  try {
    const logedUser = await user.findById(req.user.id);

    res.status(200).json({
      success: true,
      data: logedUser,
    });
  } catch (err) {
    next(err);
  }
};
//@desc         Get Current Login user
//@route        Get /api/v1/auth/me
//@access       private

exports.getSingleUser = async (req, res, next) => {
  try {
    const User = await user.findOne({ firstName: req.params.firstName });

    if (!User) {
      return next(
        new ErrorResponse(
          `User not Found With name of ${req.params.firstName}`,
          404
        )
      );
    }
    res.status(200).json({ success: true, data: User });
  } catch (err) {
    next(err);
  }
};

/* User.findOne({ username: req.params.username }, (err, result) => {
    if (err) return res.status(500).json({ msg: err });
    if (result !== null) {
      return res.json({
        Status: true,
      });
    } else
      return res.json({
        Status: false,
      });
  });*/

//@desc         Get a user
//@route        Get /api/v1/auth/me
//@access       private

exports.getMe = async (req, res, next) => {
  try {
    const logedUser = await user.findById(req.user.id);

    res.status(200).json({
      success: true,
      data: logedUser,
    });
  } catch (err) {
    next(err);
  }
};

//@desc     Get all users
//@route    Get /api/v1/users
//@access   Public
exports.getUsers = async (req, res, next) => {
  try {
    const users = await user.find();
    res.status(200).json({ success: true, count: users.length, data: users });
  } catch (err) {
    next(err);
  }
};

//Get token from model,create cookie and send response
const sendTokenResponse = (user, statusCode, res) => {
  //Create Token
  const token = user.getSignedJwtToken();

  const options = {
    expires: new Date(
      Date.now() + process.env.JWT_COOKIE_EXPIRE * 24 * 60 * 60 * 1000
    ),
    httpOnly: true,
  };
  //prevent showing cookie in the production mode
  if (process.env.NODE_ENV === "production") {
    options.secure = true;
  }

  res.status(statusCode).cookie("token", token, options).json({
    success: true,
    token,
  });
};

//@desc     signout User
//@route    Get /api/v1/signoutUser
//@access   Public
exports.signoutUser = async (req, res, next) => {
  try {
    res.clearCookie("token");
    res.status(200).json({ success: true, message: "Signout success" });
  } catch (err) {
    next(err);
  }
};
