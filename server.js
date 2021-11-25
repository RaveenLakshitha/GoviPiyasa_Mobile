const express = require("express");
const dotenv = require("dotenv");
const morgan = require("morgan");
const path = require("path");
// Route Files
const shops = require("./routes/shop");
const architects = require("./routes/Architects/architect");
//const awardsAndPubd = require("./routes/Architects/awards&pubs");
//const projects = require("./routes/Architects/projects");
const users = require("./routes/user");
const auths = require("./routes/auth");
const categories = require("./routes/category");
const items = require("./routes/item");
const advertisements = require("./routes/advertisement");
const connectDB = require("./config/db");
const cookieParser = require("cookie-parser");
const errorHandler = require("./middleware/error");
const cors = require("cors");
//Read & Load env vars to process.env
dotenv.config({ path: "./config/config.env" });

const PORT = process.env.PORT || 5000;

//Connect Database
connectDB();

const app = express();
app.use(cors());
//body parser
app.use(express.json());

//cookie parser
app.use(cookieParser());

//Dev logging middleware
if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}
//Set static folder
app.use(express.static(path.join(__dirname, "uploads")));
// Mount routes
app.use("/api/v1/shops", shops);
app.use("/api/v1/architects", architects);
//app.use("/api/v1/architects/awardsAndPubd", awardsAndPubd);
//app.use("/api/v1/architects/projects", projects);
app.use("/api/v1/users", users);
app.use("/api/v1/auths", auths);
app.use("/api/v1/items", items);
app.use("/api/v1/categories", categories);
app.use("/api/v1/advertisements", advertisements);

//ErrorHandler(Must after mounting routes)
app.use(errorHandler);

const server = app.listen(PORT, () => {
  console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});

//Handle unhandled promise rejections
process.on("unhandledRejection", (err, promise) => {
  console.log(`Error ${err.message}`);
  server.close(() => process.exit(1));
});
