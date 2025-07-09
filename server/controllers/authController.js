const crypto = require("crypto");
const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const catchAsync = require("../utils/catchAsync");
const User = require("./../models/userModel");
const AppError = require("../utils/appError");
const sendEmail = require("../utils/email");

const signToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRY,
  });
};

const createSendToken = (user, statusCode, res) => {
  const token = signToken(user._id);

  res.status(statusCode).json({
    status: "success",
    token,
    data: {
      user,
    },
  });
};

exports.signup = catchAsync(async (req, res, next) => {
  //DONT'T FORGET TO CHANGE
  console.log(req.body);
  const user = await User.findOne({ email: req.body.email });
  
  if (user) {
    return next(new AppError("User already Exists!", 400));
  }
  
  const newUser = await User.create(req.body);

  createSendToken(newUser, 201, res);
});

exports.login = catchAsync(async (req, res, next) => {
  const { email, password } = req.body;

  // check if email and password exist
  if (!email || !password) {
    return next(new AppError("Please provide email and password", 400));
  }
  // check if user exists
  const user = await User.findOne({ email }).select("+password");

  if (!user || !(await user.correctPassword(password, user.password))) {
    return next(new AppError("Incorrect email or password", 401));
  }

  createSendToken(user, 200, res);
});

exports.protect = catchAsync(async (req, res, next) => {
  //checking token exists
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }

  if (!token) {
    return next(new AppError("You aren't logged in", 401));
  }
  //validate token
  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
  //check if user exists
  const currentUser = await User.findById(decoded.id);

  if (!currentUser) {
    return next(
      new AppError("The user belonging to this token doesn't exist"),
      401
    );
  }

  if (currentUser.changedPasswordAfter(decoded.iat)) {
    return next(new AppError("User Password recently changed!"));
  }

  //check if user changed passwrd after token was issued
  req.user = currentUser;
  next();
});

exports.forgotPassword = catchAsync(async (req, res, next) => {
  const user = await User.findOne({ email: req.body.email });

  if (!user) {
    return next(new AppError("No User found!"), 404);
  }

  const resetToken = user.createPasswordResetToken();
  await user.save({ validateBeforeSave: false });

  const resetURL = `${req.protocol}://${req.get(
    "host"
  )}/api/users/resetPassword/${resetToken}`;

  const message = `Forgot your password?: ${resetURL}`;

  try {
    await sendEmail({
      email: "yabsira21116@gmail.com",
      subject: "Password reset",
      message,
    });

    res.status(200).json({
      status: "success",
      message: "Token sent to email!",
    });
  } catch (err) {
    user.passwordResetExpires = undefined;
    user.passwordResetToken = undefined;
    await user.save({ validateBeforeSave: false });

    return next(new AppError("There was an error sending the email!", 500));
  }
});

exports.resetPassword = catchAsync(async (req, res, next) => {
  const hashedToken = crypto
    .createHash("sha256")
    .update(req.params.token)
    .digest("hex");

  const user = await User.findOne({
    passwordResetToken: hashedToken,
    passwordResetExpires: { $gt: Date.now() },
  });

  if (!user) {
    return next(new AppError("Token is Invalid or exipred", 400));
  }

  user.password = req.body.password;
  user.passwordResetExpires = undefined;
  user.passwordResetToken = undefined;

  await user.save();

  createSendToken(user, 200, res);
});

exports.updatePassword = catchAsync(async (req, res, next) => {
  const user = await User.findById(req.user.id).select(+password);

  if (!(await user.correctPassword(req.body.oldPassword, user.password))) {
    return next(new AppError("Your current Password is wrong", 401));
  }

  user.password = req.body.password;
  await user.save();

  createSendToken(user, 200, res);
});

exports.getUserData = catchAsync(async (req, res, next) => {
  //checking token exists
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }

  //validate token
  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
  //check if user exists
  const currentUser = await User.findById(decoded.id);

  if (!currentUser) {
    return next(
      new AppError("The user belonging to this token doesn't exist"),
      401
    );
  }

  if (currentUser.changedPasswordAfter(decoded.iat)) {
    return next(new AppError("User Password recently changed!"));
  }
  
  res.status(200).json({
    status: "success",
    token,
    data: {
      currentUser,
    },
  });

  //check if user changed passwrd after token was issued
});
