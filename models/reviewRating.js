const mongoose = require("mongoose");

const reviewRatingSchema = mongoose.Schema({
  review: {
    type: String,
    required: true,
    min: 10,
    trim: true,
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  item: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Item",
  },
});

module.exports = mongoose.model("ReviewsRatings", reviewRatingSchema);
