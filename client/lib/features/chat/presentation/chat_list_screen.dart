// // features/chat/presentation/chat_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:homekey_mobile/features/chat/provider/chat_provider.dart';
// import '../model/chat_model.dart';
// import 'chat_screen.dart';

// class ChatListScreen extends ConsumerWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final chatsAsync = ref.watch(chatsProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Messages')),
//       body: chatsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (chats) {
//           if (chats.isEmpty) {
//             return const Center(child: Text('No chats yet'));
//           }
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               // You'll need to get the other user's name here
//               print("xoxo");
//               print(chat.members);
//               final otherUserId = chat.members.firstWhere(
//                 (id) => id != '', // Replace with current user ID
//               );
//               return ListTile(
//                 leading: const CircleAvatar(
//                   backgroundImage: AssetImage('assets/default_profile.png'),
//                 ),
//                 title: Text(
//                   'Chat with $otherUserId',
//                 ), // Replace with actual name
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(chat: chat),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import 'package:homekey_mobile/features/chat/provider/chat_provider.dart';
import 'package:homekey_mobile/features/user/provider/user_provider.dart';
import '../model/chat_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatsProvider);
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.value?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet'));
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherUserId = chat.members.firstWhere(
                (id) => id != currentUserId,
              );

              final otherUserAsync = ref.watch(
                userDetailsProvider(otherUserId),
              );

              return otherUserAsync.when(
                loading:
                    () => ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/default_profile.png',
                        ),
                      ),
                      title: const Text('Loading...'),
                    ),
                error:
                    (error, stack) => ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/default_profile.png',
                        ),
                      ),
                      title: Text('Unknown User ($otherUserId)'),
                    ),
                data:
                    (otherUser) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            const AssetImage('assets/pp.jpg') as ImageProvider,
                      ),
                      title: Text(otherUser?.name ?? 'Unknown User'),
                      subtitle: Text(otherUser?.email ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chat: chat),
                          ),
                        );
                      },
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
