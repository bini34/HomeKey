const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  property: {
    type: mongoose.Schema.ObjectId,
    ref: "Property",
    required: [true, "Booking must belong to property"],
    unique: true,
  },
  user: {
    type: mongoose.Schema.ObjectId,
    ref: "User",
    required: [true, "Booking must belong to user"],
  },
  startDate: {
    type: Date,
  },
  endDate: {
    type: Date,
  },
});

bookingSchema.index({ property: 1, user: 1 }, { unique: true });

const Booking = mongoose.model("Booking", bookingSchema);

module.exports = Booking;
