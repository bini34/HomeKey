import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/notification/data/data_sources/local/hive_notification_data_source.dart";
import "package:MediTrack/features/notification/data/data_sources/remote/firebase_notification_data_source.dart";
import "package:MediTrack/features/notification/data/repository/notification_repository_impl.dart";
import "package:MediTrack/features/notification/domain/entity/notification.dart";
import "package:MediTrack/features/notification/domain/useCase/clear_notification.dart";
import "package:MediTrack/features/notification/domain/useCase/get_notifications.dart";
import "package:MediTrack/features/notification/domain/useCase/mark_notification_read.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>(
      (ref) => HiveNotificationDataSource(),
    );

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>(
      (ref) => FirebaseNotificationDataSource(),
    );

final notificationRepositoryProvider = Provider<NotificationRepositoryImpl>(
  (ref) => NotificationRepositoryImpl(
    localDataSource: ref.read(notificationLocalDataSourceProvider),
    remoteDataSource: ref.read(notificationRemoteDataSourceProvider),
  ),
);

final getNotificationsUseCaseProvider = Provider<GetNotifications>(
  (ref) => GetNotifications(ref.read(notificationRepositoryProvider)),
);

final markNotificationReadUseCaseProvider = Provider<MarkNotificationRead>(
  (ref) => MarkNotificationRead(ref.read(notificationRepositoryProvider)),
);

final clearNotificationUseCaseProvider = Provider<ClearNotification>(
  (ref) => ClearNotification(ref.read(notificationRepositoryProvider)),
);

final notificationListProvider = StateNotifierProvider<
  NotificationNotifier,
  AsyncValue<List<Notification>>
>((ref) {
  final userId = ref.watch(userProvider)?.userId;
  if (userId == null) {
    return const AsyncValue.data([]);
  }
  return NotificationNotifier(ref.read(notificationRepositoryProvider), userId);
});

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<Notification>>> {
  final NotificationRepositoryImpl _notificationRepository;
  final String _userId;

  NotificationNotifier(this._notificationRepository, this._userId)
    : super(const AsyncValue.loading()) {
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      state = const AsyncValue.loading();
      final notifications = await _notificationRepository.getAllNotifications(
        _userId,
      );
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNotification(Notification notification) async {
    try {
      await _notificationRepository.createNotification(notification);
      await _fetchNotifications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(Notification notification) async {
    try {
      await _notificationRepository.updateNotification(
        notification.copyWith(isRead: true),
      );
      await _fetchNotifications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearNotification(String notificationId) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      await _fetchNotifications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
