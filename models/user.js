const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
jwt = require("jsonwebtoken");
const slugify = require("slugify");
const userSchema = new mongoose.Schema(
  {
    firstName: {
      type: String,
      min: 3,
      max: 20,
      // required: true,
      trim: true,
    },
    lastName: {
      type: String,
      min: 3,
      max: 20,
      // required: true,
      trim: true,
    },
    slug: String,
    email: {
      type: String,
      unique: true,
      // required: true,
      trim: true,
      lowercase: true,
      match: [
        /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
        "Please add a valid email",
      ],
    },
    password: {
      type: String,
      required: [true, "Please add a Password"],
      min: 6,
      select: false,
    },
    address: {
      type: String,
      //required: [true, "Please add a Address"],
      min: 6,
      max: 10,
      select: false,
    },
    city: {
      type: String,
      //required: true,
      trim: true,
    },
    contactNumber: {
      type: String,
      //required: true,
      minlength: 10,
      trim: true,
    },
    role: {
      type: String,
      enum: ["admin", "user"],
      default: "user",
    },
    profilePicture: { type: String },
    interestedCategories: {
      type: String,
      enum: ["flowergardening", "vegetablegardening", "economicalcrops"],
    },
    createdDate: { type: Date },
  },
  { timeStamps: true }
);
// Create users slugify from name
userSchema.pre("save", function (next) {
  this.slug = slugify(this.email, { lower: true });
  next();
});

//Encrypt password using bcrypt
userSchema.pre("save", async function (next) {
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

//Sign JWT and Return
userSchema.methods.getSignedJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE,
  });
};

//Match user entered password and hash+password in database
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = mongoose.model("User", userSchema);
