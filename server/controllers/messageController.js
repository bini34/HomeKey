const Message = require("../models/messageModel");
const catchAsync = require("../utils/catchAsync");

exports.addMsg = catchAsync(async (req, res, next) => {
  const { chatId, senderId, text } = req.body;

  const message = new Message({
    chatId,
    senderId,
    text,
  });

  const result = await message.save();
  res.status(200).json({
    status: "success",
    data: {
      message: result,
    },
  });
});

exports.getMsg = catchAsync(async (req, res, next) => {
  const { chatId } = req.params;

  const result = await Message.find({ chatId });

  res.status(200).json({
    status: "success",
    data: {
      result,
    },
  });
});

exports.getLatestMessages = catchAsync(async (req, res, next) => {
  const { chatIds } = req.body;

  console.log(chatIds);

  const latestMessages = await Message.aggregate([
    {
      $match: { chatId: { $in: chatIds } },
    },
    {
      $sort: { createdAt: -1 },
    },
    {
      $group: {
        _id: "$chatId",
        latestMessage: { $first: "$$ROOT" },
      },
    },
    {
      // Project to include only the chatId and the text field from the latestMessage
      $project: {
        _id: 0,
        chatId: "$_id",
        text: "$latestMessage.text",
        createdAt: "$latestMessage.createdAt"
      },
    },
  ]);

  res.status(200).json({ success: true, data: latestMessages });
});
