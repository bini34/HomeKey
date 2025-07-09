const Chat = require("../models/chatModel");
const catchAsync = require("../utils/catchAsync");

exports.createChat = catchAsync(async (req, res, next) => {
  req.body.senderId = req.user.id;
  console.log(req.user.id, req.body.receiverId);

  const existingChat = await Chat.findOne({
    members: { $all: [req.body.senderId, req.body.receiverId] }, // Check for both members in the array
  });

  console.log(existingChat);

  if (existingChat) {
    // Return the existing chat or handle it as needed
    return res.status(200).json({
      status: "success",
      data: {
        chat: existingChat,
      },
    });
  }

  const newChat = new Chat({
    members: [req.body.senderId, req.body.receiverId],
  });

  const result = await newChat.save();
  res.status(200).json({
    status: "success",
    data: {
      chat: result,
    },
  });
});

exports.userChats = catchAsync(async (req, res, next) => {
  const chat = await Chat.find({
    members: { $in: [req.params.userId] },
  });

  res.status(200).json({
    status: "success",
    data: {
      chat,
    },
  });
});

exports.findChat = catchAsync(async (req, res, next) => {
  const chat = await Chat.findOne({
    members: { $all: [req.params.firstId, req.params.secondId] },
  });

  res.status(200).json({
    status: "success",
    data: {
      chat,
    },
  });
});
