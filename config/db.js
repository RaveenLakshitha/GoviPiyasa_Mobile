const mongoose = require("mongoose");
const multer = require("multer");
const connectStorage = require("./storage");
const Grid = require("gridfs-stream");
const crypto = require("crypto");
const { GridFsStorage } = require("multer-gridfs-storage");

Grid.mongo = mongoose.mongo;

const connectDB = async () => {
  const conn = await mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  //const conn = mongoose.createConnection(process.env.MONGO_URI);
  console.log(`MongoDB Connected: ${conn.connection.host}`);
  //console.log(`MongoDB Connected:`);
  //From here
  /* let gfs;

  await mongoose.connection.once("open", () => {
    //Init Stream
    gfs = Grid(conn.db, mongo);
    gfs.collection("uploads");
  }); */
};

module.exports = connectDB;
