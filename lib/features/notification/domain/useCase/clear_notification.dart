import "package:MediTrack/features/notification/domain/repositories/notification_repository.dart";

class ClearNotification {
  final NotificationRepository repository;

  ClearNotification(this.repository);

  Future<void> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}
