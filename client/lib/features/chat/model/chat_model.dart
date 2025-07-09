// features/chat/model/chat_model.dart
class Chat {
  final String id;
  final List<String> members;
  final DateTime createdAt;

  Chat({required this.id, required this.members, required this.createdAt});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      members: List<String>.from(json['members']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
