const mongoose = require("mongoose");
jwt = require("jsonwebtoken");

const shopSchema = new mongoose.Schema(
  {
    shopName: {
      type: String,
      min: 3,
      max: 20,
      //required: true,
      trim: true,
    },
    slug: String,
    category: {
      type: String,
      enum: ["flowergardening", "vegetablegardening", "economicalcrops"],
    },
    contactNumber: {
      type: String,
      //required: true,
      minlength: 10,
      trim: true,
    },
    email: {
      type: String,
      unique: true,
      //required: true,
      trim: true,
      lowercase: true,
      match: [
        /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
        "Please add a valid email",
      ],
    },
    address: {
      type: String,
      //required: [true, "Please add a Address"],
      min: 6,
      max: 10,
      select: false,
    },
    zipCode: {
      type: String,
    },
    city: {
      type: String,
      //required: true,
      trim: true,
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    shopReviews: [
      {
        userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      },
    ],
    shopItems: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Item",
      },
    ],
    orders: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Order",
      },
    ],
    logo: { type: String },
    coverImage: { type: String },
    createdDate: { type: Date },
  },
  {
    toObject: { virtuals: true },
    toJson: { virtuals: true },
  }
);
//Reverse populate
shopSchema.virtual("items", {
  ref: "Item",
  localField: "_id",
  foreignField: "shopId",
});

//Sign JWT and Return
shopSchema.methods.getShopSignedJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE,
  });
};

module.exports = mongoose.model("Shop", shopSchema);
