const ErrorResponse = require("../utils/errorResponse");
const jwt = require("jsonwebtoken");
const Shop = require("../models/shop");
const asyncHandler = require("./async");

exports.accessShop = async (req, res, next) => {
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
      req.shop = await Shop.findById(decoded.id);
      console.log(req.shop);
      next();
    } catch (err) {
      return next(err);
    }
  } catch (err) {
    next(err);
  }
};
