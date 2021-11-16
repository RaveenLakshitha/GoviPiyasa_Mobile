const ErrorResponse = require("../utils/errorResponse");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const asyncHandler = require("./async");

exports.protect = async (req, res, next) => {
  try {
    let token;

    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    } /* else if (req.cookies.token) {
      token = req.cookies.token;
    } */

    //Make sure token exists
    if (!token) {
      return next(new ErrorResponse("Not authorize to access this route", 401));
    }

    try {
      //verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log(decoded);
      req.user = await User.findById(decoded.id);
      console.log(req.user);
      next();
    } catch (err) {
      return next(new ErrorResponse("Not authorize to access this route", 401));
    }
  } catch (err) {
    next(err);
  }
};
