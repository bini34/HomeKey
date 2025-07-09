// features/chat/model/message_model.dart
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
