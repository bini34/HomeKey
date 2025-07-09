// features/chat/presentation/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import 'package:homekey_mobile/features/chat/provider/chat_provider.dart';
import 'package:homekey_mobile/features/chat/service/socket_service.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../repository/chat_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SocketService _socketService = SocketService();
  List<Message> _messages = [];
  late String currentUserId;
  bool _isLoadingMessages = true; // New state for loading messages
  bool _isSendingMessage = false; // New state for sending message

  @override
  void initState() {
    super.initState();
    _loadMessages();

    final authState = ref.read(authControllerProvider);
    final user = authState.value;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    currentUserId = user.id;

    _socketService.initialize(currentUserId);

    _socketService.listenForMessages((data) {
      // print("socket chat id, ${widget.chat.id}");
      // print("socket current user id, ${data['chatId'] == widget.chat.id}");
      // print("socket data, $data");
      // if (data['chatId'] == widget.chat.id) {
      //   setState(() {
      //     _messages.add(
      //       Message(
      //         id: '',
      //         chatId: data['chatId'],
      //         senderId: data['senderId'],
      //         text: data['text'],
      //         createdAt: DateTime.now(),
      //       ),
      //     );
      //     print("socket message, ${_messages.last}");
      //     _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      //   });
      // }
      print("Socket data received: $data");
      print("Current chat ID: ${widget.chat.id}");
      print(
        "Comparing: ${data['chatId']} == ${widget.chat.id} is ${data['chatId'] == widget.chat.id}",
      );

      if (data['chatId'] == widget.chat.id) {
        final newMessage = Message(
          id: data['id'] ?? '', // Make sure to handle potential missing fields
          chatId: data['chatId'],
          senderId: data['senderId'],
          text: data['text'],
          createdAt: DateTime.now(),
        );

        print("Created new message: $newMessage");

        setState(() {
          _messages.add(newMessage);
          // Sort messages after adding
          _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          print("Messages list after adding: ${_messages.length} messages");
        });
      } else {
        print("Message discarded - chat ID mismatch");
      }

      _refreshMessages(); //
    });
  }

  void _refreshMessages() async {
    print("Manually refreshing messages");
    await _loadMessages();
    print("Messages refreshed, count: ${_messages.length}");
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoadingMessages = true; // Set loading to true before fetching
    });
    try {
      final repository = ref.read(chatRepositoryProvider);
      final messages = await repository.getChatMessages(widget.chat.id);
      setState(() {
        _messages =
            messages..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load messages: $e')));
    } finally {
      setState(() {
        _isLoadingMessages = false; // Set loading to false after fetching
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isSendingMessage = true; // Set sending to true before sending
    });

    try {
      final repository = ref.read(chatRepositoryProvider);
      final authState = ref.read(authControllerProvider);
      final user = authState.value;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      currentUserId = user.id;
      final message = await repository.sendMessage(
        chatId: widget.chat.id,
        senderId: currentUserId,
        text: _messageController.text,
      );

      final receiverId = widget.chat.members.firstWhere(
        (id) => id != currentUserId,
      );
      _socketService.sendMessage({
        'chatId': widget.chat.id,
        'senderId': currentUserId,
        'receiverId': receiverId,
        'text': _messageController.text,
      });

      _messageController.clear();
      setState(() {
        _messages.insert(0, message);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
    } finally {
      setState(() {
        _isSendingMessage = false; // Set sending to false after sending
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherUserId = widget.chat.members.firstWhere(
      (id) => id != currentUserId,
      orElse: () => 'User',
    );

    return Scaffold(
      appBar: AppBar(title: Text('Chat with $otherUserId')),
      body: Column(
        children: [
          Expanded(
            child:
                _isLoadingMessages
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Spinner for loading messages
                    : ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = message.senderId == currentUserId;

                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_isSendingMessage, // Disable input while sending
                  ),
                ),
                IconButton(
                  icon:
                      _isSendingMessage
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ) // Spinner on send button
                          : const Icon(Icons.send),
                  onPressed:
                      _isSendingMessage
                          ? null
                          : _sendMessage, // Disable button while sending
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
