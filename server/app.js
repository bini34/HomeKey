const express = require("express");
const morgan = require("morgan");
const multer = require("multer");

//console.log("Current Working Directory:", process.cwd());

const fileStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Stick with forward slashes; Node.js handles it
    cb(null, "images/imageCover");
  },
  filename: (req, file, cb) => {
    // Sanitize the date string to remove colons, or use a simpler timestamp
    const datePart = new Date().toISOString().replace(/:/g, "-"); // Replaces all colons with hyphens
    const originalname = file.originalname;
    const filename = `${datePart}-${originalname}`;
    cb(null, filename);

    // OR, even simpler and very common for uniqueness:
    // const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    // const fileExtension = path.extname(file.originalname); // You'd need to require 'path'
    // cb(null, `${file.fieldname}-${uniqueSuffix}${fileExtension}`);
  },
});

const fileFilter = (req, file, cb) => {
  if (
    file.mimetype === "image/png" ||
    file.mimetype === "image/jpg" ||
    file.mimetype === "image/jpeg"
  ) {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const AppError = require("./utils/appError");
const globalErrorHandler = require("./controllers/errorController");
const propertyRoute = require("./routes/propertyRoute");
const userRoute = require("./routes/userRoute");
const chatRoute = require("./routes/chatRoute");
const messageRoute = require("./routes/messageRoute");
// const reviewRoute = require("./routes/reviewRoute");

const app = express();

if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}

app.use(express.json());
app.use(
  multer({ storage: fileStorage, fileFilter: fileFilter }).array("images", 4)
);
app.use(express.static(`${__dirname}/images`));

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "*");
  res.setHeader("Access-Control-Allow-Headers", "*");
  next();
});

app.use("/api", propertyRoute);
app.use("/api", userRoute);
/* new */
app.use("/api/chat", chatRoute);
app.use("/api/msg", messageRoute);
// app.use("/api", reviewRoute);

app.all("*", (req, res, next) => {
  next(new AppError(`Can't find $${req.originalUrl} on this server`, 404));
});

app.use(globalErrorHandler);

module.exports = app;

// mongoose
//   .connect(
//     "mongodb+srv://yabsiradarkmatterred:GsvEsgUEcHPC6zLV@homekey.uvopu.mongodb.net/?retryWrites=true&w=majority&appName=Homekey"
//   )
//   .then((res) => {
//     console.log("Connected!");
// })
// .catch((err) => console.log(err));
