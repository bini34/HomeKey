// features/chat/repository/chat_repository.dart
import 'dart:convert';
import 'package:homekey_mobile/features/auth/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatRepository {
  final String _baseUrl = 'http://10.119.27.17:8080/api';
  final String _socketUrl = 'http://10.119.27.17:8800';
  final AuthStorageService _storage = AuthStorageService();

  Future<List<Chat>> getUserChats(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chat/$userId'), // Matches GET /api/chat/:userId
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data']['chat'] as List)
          .map((chat) => Chat.fromJson(chat))
          .toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<Message>> getChatMessages(String chatId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/msg/$chatId'), // Matches GET /api/msg/:chatId
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data']['result'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/msg/'), // Matches POST /api/msg/
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'chatId': chatId, 'senderId': senderId, 'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Message.fromJson(data['data']['message']);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<Chat> createChat({
    required String senderId,
    required String receiverId,
  }) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Not authenticated');
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/'), // Matches POST /api/chat/
      headers: {
        'Content-Type': 'application/json',
        // You'll need to add auth token here
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'senderId': senderId, 'receiverId': receiverId}),
    );

    print('Create chat response status: ${response.statusCode}');
    print('Create chat response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Chat.fromJson(data['data']['chat']);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  Future<List<Message>> getLatestMessages(List<String> chatIds) async {
    final response = await http.post(
      Uri.parse(
        '$_baseUrl/msg/latest-message',
      ), // Matches POST /api/msg/latest-message
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'chatIds': chatIds}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList();
    } else {
      throw Exception('Failed to load latest messages');
    }
  }
}
