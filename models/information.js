const mongoose = require("mongoose");

const information = mongoose.Schema({
  Title: {
    type: String,
    //required: true,
  },
  category: {
    type: String,
    ref: "Category",
    //required: true,
  },
  Description: {
    type: String,
    //required: true,
  },
  Image: {
    type: String,
    //required: true,
  },
  DateAndTime: {
    type: String,
    //required: true,
  },
});

module.exports = mongoose.model("Information", information);
