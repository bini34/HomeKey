const Booking = require("../models/bookingModel");
const Property = require("../models/propertyModel");
const catchAsync = require("../utils/catchAsync");
const AppError = require("../utils/appError");

exports.createBooking = catchAsync(async (req, res, next) => {
  if (!req.body.property) req.body.property = req.params.propertyId;
  if (!req.body.user) req.body.user = req.user.id;

  const newBooking = await Booking.create(req.body);

  const property = await Property.findOne({
    _id: req.params.propertyId,
  });

  if (!property) {
    return next(new AppError("Property doesn't exist", 400));
  }

  property.avilablity = false;

  await property.save();

  res.status(201).json({
    status: "success",
    data: {
      booking: newBooking,
    },
  });
});
