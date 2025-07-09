// features/chat/provider/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import '../repository/chat_repository.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final chatsProvider = FutureProvider.autoDispose<List<Chat>>((ref) async {
  final repository = ref.read(chatRepositoryProvider);
  final authState = ref.watch(authControllerProvider);
  final user = authState.value;
  final userId = user?.id ?? '';
  print('Fetching chats for user: $userId');
  return repository.getUserChats(userId);
});

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<List<Chat>>>((ref) {
      final repository = ref.read(chatRepositoryProvider);
      return ChatController(repository, ref);
    });

class ChatController extends StateNotifier<AsyncValue<List<Chat>>> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatController(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadChats();
  }

  Future<void> loadChats() async {
    state = const AsyncValue.loading();
    try {
      // Get the current auth state
      final authState = _ref.read(authControllerProvider);
      final user = authState.value;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userId = user.id;
      print('Loading chats for user: $userId');

      final chats = await _repository.getUserChats(userId);
      state = AsyncValue.data(chats);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Chat> createChat(String receiverId) async {
    try {
      // Get the current auth state
      final authState = _ref.read(authControllerProvider);
      final user = authState.value;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final senderId = user.id;
      final chat = await _repository.createChat(
        senderId: senderId,
        receiverId: receiverId,
      );
      await loadChats(); // Refresh the list
      return chat;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
