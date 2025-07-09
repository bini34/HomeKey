const mongoose = require("mongoose");
const Property = require("./propertyModel");

const reviewSchema = new mongoose.Schema(
  {
    review: {
      type: String,
      required: [true, "Review can't be empty."],
    },
    rating: {
      type: Number,
      min: 1,
      max: 5,
    },
    createdAt: {
      type: Date,
      default: Date.now(),
    },
    property: {
      type: mongoose.Schema.ObjectId,
      ref: "Property",
      required: [true, "Review must belong to a property."],
    },
    user: {
      type: mongoose.Schema.ObjectId,
      ref: "User",
      required: [true, "Review must belong to a user."],
    },
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

reviewSchema.index({ property: 1, user: 1 }, { unique: true });

reviewSchema.statics.calcAvgRatings = async function (propertyId) {
  const stats = await this.aggregate([
    {
      $match: { property: propertyId },
    },
    {
      $group: {
        _id: "$property",
        nRating: { $sum: 1 },
        avgRating: { $avg: "$rating" },
      },
    },
  ]);

  if (stats.length > 0) {
    await Property.findByIdAndUpdate(propertyId, {
      ratingAverage: stats[0].nRating,
      ratingsQuantity: stats[0].avgRating,
    });
  } else {
    await Property.findByIdAndUpdate(propertyId, {
      ratingAverage: 0,
      ratingsQuantity: 4.5,
    });
  }
};

reviewSchema.post("save", function () {
  this.constructor.calcAvgRatings(this.property);
});

reviewSchema.pre(/^findOneAnd/, async function (next) {
  this.r = await this.clone().findOne();
  next();
});
reviewSchema.post(/^findOneAnd/, async function () {
  await this.r.constructor.calcAvgRatings(this.r.property);
});

const Review = mongoose.model("Review", reviewSchema);

module.exports = Review;
