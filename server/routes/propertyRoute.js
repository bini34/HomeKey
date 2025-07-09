const express = require("express");
const propertyController = require("../controllers/propertyController");
const authController = require("../controllers/authController");
const reviewController = require("../controllers/reviewController");
const bookingController = require("../controllers/bookingController");

const router = express.Router();

// router.param("id", propertyController.checkId);

// GET /api/properties
router.get(
  "/properties",
  authController.protect,
  propertyController.getAllProperties
);

router.get(
  "/propertiesFeed",
  authController.protect,
  propertyController.getAllPropertiesExceptMine
);

router.get("/allProperties", propertyController.getAllPropertiesForAll);

router.get(
  "/property/property-within/:distance/center/:latlng/",
  propertyController.getPropertyWithin
);

//GET /api/property/properties-stats
router.get("/property/stats/", propertyController.getPropertyStats);

// GET /api/property/:id
router.get(
  "/property/:id",
  authController.protect,
  propertyController.getProperty
);

//PATCH /api/property/:id
router.patch(
  "/property/:id",
  authController.protect,
  propertyController.updateProperty
);

//DELETE /api/property/:id
router.delete(
  "/property/:id",
  authController.protect,
  propertyController.deleteProperty
);

// POST /api/property
router.post(
  "/property",
  authController.protect,
  propertyController.postProperty
);

//reviews
router.get("/property/:propertyId/reviews", reviewController.getAllReviews);

router.post(
  "/property/:propertyId/reviews",
  authController.protect,
  reviewController.createReview
);

router.delete(
  "/reviews/:id",
  authController.protect,
  reviewController.delReview
);

//bookings
router.post(
  "/property/:propertyId/booking",
  authController.protect,
  bookingController.createBooking
);

module.exports = router;
