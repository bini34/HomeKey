const express = require("express");
const messageController = require("../controllers/messageController.js");

const router = express.Router();

router.post("/", messageController.addMsg);

router.post("/latest-message", messageController.getLatestMessages);

router.get("/:chatId", messageController.getMsg);

module.exports = router;
