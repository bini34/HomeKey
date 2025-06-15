import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/notification/presentation/providers/notification_provider.dart";

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              // TODO: Implement mark all as read
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // TODO: Implement clear all notifications
            },
          ),
        ],
      ),
      body: notificationsAsyncValue.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text("No new notifications."));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: notification.isRead ? Colors.white : Colors.blue.shade50,
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    notification.timestamp.toLocal().toString().split(".")[0],
                  ),
                  onTap: () {
                    if (!notification.isRead) {
                      ref
                          .read(notificationListProvider.notifier)
                          .markAsRead(notification.copyWith(isRead: true));
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
