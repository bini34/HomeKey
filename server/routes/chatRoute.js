
const authController = require("../controllers/authController");
const chatController = require("../controllers/chatController.js");

const express = require("express");

const router = express.Router();

router.post("/", authController.protect, chatController.createChat);

router.get("/:userId", chatController.userChats);

router.get("/find/:firstId/:secondId", chatController.findChat);

module.exports = router;
