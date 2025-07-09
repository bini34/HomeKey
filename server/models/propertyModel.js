const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const PropertySchema = new Schema(
  {
    author: {
      type: mongoose.Schema.ObjectId,
      ref: "User",
    },
    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: [
        40,
        "A Property name must have less or equal to 40 characters.",
      ],
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    price: {
      type: Number,
      required: true,
    },
    type: {
      type: String,
      required: true,
      enum: {
        values: ["Flat", "House", "Villa", "Studio"],
        message: "Difficulty is enum",
      },
    },
    area: {
      type: Number,
      required: true,
    },
    bedroom: {
      type: Number,
      required: true,
    },
    ratingAverage: {
      type: Number,
      default: 4.5,
      set: (val) => Math.round(val * 10) / 10,
    },
    ratingsQuantity: {
      type: Number,
      default: 0,
    },
    imageCover: {
      type: String,
    },
    images: [String],
    location: {
      type: {
        type: String,
        default: "Point",
        enum: ["Point"],
      },
      coordinates: [Number],
      address: String,
      description: String,
    },
    amenity: [String],
    nearbyActivities: [String],
    avilablity: {
      type: Boolean,
      default: true,
    },
    createdAt: {
      type: Date,
      default: Date.now(),
      select: false,
    },
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

PropertySchema.index({ price: 1, ratingAverage: -1 });
PropertySchema.index({ location: "2dsphere" });

// virtual populate
PropertySchema.virtual("reviews", {
  ref: "Review",
  foreignField: "property",
  localField: "_id",
});

module.exports = mongoose.model("Property", PropertySchema);

// propertyId: Unique identifier for the property
// ownerId: Reference to the user who posted the property (seller)

// title: Title of the property listing
// description: Detailed description
// price: Price of the property
// location: Property location details (city, state, zip code)
// type: Property type (e.g., house, apartment)
// size: Size of the property (square feet)
// numberOfRooms: Number of rooms
// amentiy: pluses
// nearbyActivity
// images: Array of image URLs
// status: Status of the property (available, sold, pending)
// comments: Array of references to review objects associated with the property
// createdAt: Listing creation date
