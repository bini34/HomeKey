const mongoose = require("mongoose");

const MessageSchema = new mongoose.Schema(
  {
    chatId: {
      type: String,
    },
    senderId: {
      type: String,
    },
    text: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

const MessageModel = mongoose.model("Message", MessageSchema);

module.exports = MessageModel;

/*
const ChatModel = require("./ChatModel");
const MessageModel = require("./MessageModel");
const mongoose = require("mongoose");

async function getSortedChats(userId) {
  try {
    const chats = await ChatModel.aggregate([
      {
        $match: {
          members: { $in: [userId] }, // Optional: Filter chats by a specific user
        },
      },
      {
        $lookup: {
          from: "messages", // The name of the Message collection
          localField: "_id",
          foreignField: "chatId",
          as: "messages",
        },
      },
      {
        $addFields: {
          latestMessage: { $arrayElemAt: [{ $slice: ["$messages", -1] }, 0] }, // Get the latest message
        },
      },
      {
        $sort: {
          "latestMessage.createdAt": -1, // Sort by the latest message's timestamp (descending)
        },
      },
      {
        $project: {
          messages: 0, // Optionally exclude the messages array from the result
        },
      },
    ]);

    return chats;
  } catch (err) {
    console.error(err);
    throw new Error("Failed to get sorted chats");
  }
}
*/
