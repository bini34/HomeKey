const express = require("express");

const authController = require("../controllers/authController");
const userController = require("../controllers/userController");

const router = express.Router();

// GET /api/users
router.get("/users", userController.getAllUsers);

router.get(
  "/users/search/:userName",
  authController.protect,
  userController.searchUser
);

router.get("/users/getUserData", authController.getUserData);

// // GET /api/user/:id
router.get("/user/:id", userController.getUser);
// router.get("/user/:id", userController.getUser);
//POST /api/users/login
router.post("/users/login", authController.login);

// POST /api/users/signup
router.post("/users/signup", authController.signup);

router.patch(
  "/users/updateMe",
  authController.protect,
  userController.updateMe
);
router.delete(
  "/users/updateMe",
  authController.protect,
  userController.deleteMe
);

router.patch(
  "/users/updatePassword",
  authController.protect,
  authController.updatePassword
);

router.post("/users/forgotPassword", authController.forgotPassword);

router.patch("/users/resetPassword/:token", authController.resetPassword);

module.exports = router;
