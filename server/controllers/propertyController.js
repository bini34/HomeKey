const Property = require("../models/propertyModel");
const APIFeatures = require("../utils/apiFeatures");
const catchAsync = require("../utils/catchAsync");
const AppError = require("../utils/appError");

exports.getAllProperties = catchAsync(async (req, res, next) => {
  //const features = new APIFeatures(Property.find(), req.query)
  const features = new APIFeatures(
    Property.find({ author: req.user.id }).populate("author", "-password -__v"),
    req.query
  )
    .filter()
    .sort()
    .limitFields()
    .paginate();

  const totalResults = await Property.countDocuments(
    JSON.parse(features.updatedQueryString)
  );

  const properties = await features.query;

  //response
  res.status(200).json({
    status: "success",
    totalResults,
    results: properties.length,
    data: {
      properties,
    },
  });
});

exports.getAllPropertiesExceptMine = catchAsync(async (req, res, next) => {
  //const features = new APIFeatures(Property.find(), req.query)
  const features = new APIFeatures(
    Property.find({ author: { $ne: req.user.id } }).populate(
      "author",
      "-password -__v"
    ),
    req.query
  )
    .filter()
    .sort()
    .limitFields()
    .paginate();

  const totalResults = await Property.countDocuments(
    JSON.parse(features.updatedQueryString)
  );

  const properties = await features.query;

  //response
  res.status(200).json({
    status: "success",
    totalResults,
    results: properties.length,
    data: {
      properties,
    },
  });
});

// exports.getAllPropertiesForAll = catchAsync(async (req, res, next) => {
//   const features = new APIFeatures(Property.find(), req.query)
//     //const features = new APIFeatures(Property.find({author: req.user.id}), req.query)
//     .filter()
//     .sort()
//     .limitFields()
//     .paginate();

//   const totalResults = await Property.countDocuments(
//     JSON.parse(features.updatedQueryString)
//   );

//   const properties = await features.query;

//   //response
//   res.status(200).json({
//     status: "success",
//     totalResults,
//     results: properties.length,
//     data: {
//       properties,
//     },
//   });
// });

exports.getAllPropertiesForAll = catchAsync(async (req, res, next) => {
  const features = new APIFeatures(
    Property.find().populate("author", "-password -__v"),
    req.query
  )
    .filter()
    .sort()
    .limitFields()
    .paginate();

  const totalResults = await Property.countDocuments(
    JSON.parse(features.updatedQueryString)
  );

  const properties = await features.query;

  res.status(200).json({
    status: "success",
    totalResults,
    results: properties.length,
    data: {
      properties,
    },
  });
});

exports.getProperty = catchAsync(async (req, res, next) => {
  const property = await Property.findById(req.params.id)
    .populate("reviews")
    .populate("author");

  if (!property) {
    return next(new AppError("No Property found With that ID", 404));
  }

  res.status(200).json({
    status: "success",
    data: {
      property,
    },
  });
});

exports.updateProperty = catchAsync(async (req, res, next) => {
  const property = await Property.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });

  if (!property) {
    return next(new AppError("No Property found With that ID", 404));
  }

  res.status(200).json({
    status: "success",
    data: {
      property,
    },
  });
});

exports.deleteProperty = catchAsync(async (req, res, next) => {
  const property = await Property.findOneAndDelete({ _id: req.params.id });

  if (!property) {
    return next(new AppError("No Property found With that ID", 404));
  }

  res.status(204).json({
    status: "success",
    data: null,
  });
});

exports.postProperty = catchAsync(async (req, res, next) => {
  function replaceImagePath(originalPath) {
    // Step 1: Normalize the path to use forward slashes for URL compatibility
    // Multer's file.path on Windows might return 'images\imageCover\filename.jpg'
    // We need 'images/imageCover/filename.jpg' for the URL
    const normalizedPath = originalPath.replace(/\\/g, "/");

    // Step 2: Determine the base URL for your static files.
    // Based on your CURRENT app.use(express.static(`${__dirname}/images`));
    // The 'images/' part is implicitly mapped to the root of your URL.
    // So, if your originalPath is 'images/imageCover/file.jpg',
    // you only want 'imageCover/file.jpg' in the URL part.

    if (normalizedPath.startsWith("images/")) {
      // Remove the 'images/' prefix because your static server maps 'images' directory
      // directly to the root URL path.
      return normalizedPath.replace("images/", "");
    }

    // Fallback, though typically your paths will start with 'images/'
    return normalizedPath;
  }
  //setting userId to loggedIn user
  req.body.author = req.user.id;
  //req.body.author = "670f7d9a892854419079cdc1";

  req.body.amenity = JSON.parse(req.body.amenity);
  req.body.location = JSON.parse(req.body.location);
  req.body.nearbyActivities = JSON.parse(req.body.nearbyActivities);

  if (req.files) {
    let pics = [];
    for (let i = 0; i < req.files.length; i++) {
      pics.push(replaceImagePath(req.files[i].path));
    }
    //req.files.map((file) => pics.append(file.path));
    req.body.images = pics;
    req.body.imageCover = pics[0];
  }

  req.body = JSON.parse(JSON.stringify(req.body));

  const newProperty = await Property.create(req.body);

  res.status(201).json({
    status: "success",
    data: {
      property: newProperty,
    },
  });
});

exports.getPropertyStats = catchAsync(async (req, res) => {
  const stats = await Property.aggregate([
    {
      $match: { ratingAverage: { $gte: 4.5 } },
    },
    {
      $group: {
        _id: null,
        avgRating: { $avg: "$ratingAverage" },
        avgPrice: { $avg: "$price" },
      },
    },
  ]);

  res.status(200).json({
    status: "success",
    data: {
      stats,
    },
  });
});

exports.getPropertyWithin = catchAsync(async (req, res, next) => {
  const { distance, latlng } = req.params;
  const [lat, lng] = latlng.split(",");

  const radius = distance / 6378.1;

  if (!lat || !lng) {
    next(new AppError("Please provide latitude and longitude", 400));
  }

  const properties = await Property.find({
    location: { $geoWithin: { $centerSphere: [[lng, lat], radius] } },
  });

  res.status(200).json({
    status: "success",
    results: properties.length,
    data: {
      data: properties,
    },
  });
});
