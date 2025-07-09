const Review = require("../models/reviewModel");
const catchAsync = require("../utils/catchAsync");
const AppError = require("../utils/appError");

exports.getAllReviews = catchAsync(async (req, res, next) => {
  let filter = {};
  if (req.params.propertyId) filter = { property: req.params.propertyId };

  const reviews = await Review.find(filter).populate({
    path: "user",
    select: "name email",
  });

  res.status(200).json({
    status: "success",
    results: reviews.length,
    data: {
      reviews,
    },
  });
});

exports.createReview = catchAsync(async (req, res, next) => {
  console.log(req.url);
  // Allow nested routes
  if (!req.body.property) req.body.property = req.params.propertyId;
  if (!req.body.user) req.body.user = req.user.id;

  const newReview = await Review.create(req.body);

  res.status(201).json({
    status: "success",
    data: {
      review: newReview,
    },
  });
});

exports.delReview = catchAsync(async (req, res, next) => {
  await Review.findOneAndDelete(req.params.id);

  res.status(201).json({
    status: "success",
    data: null,
  });
});
