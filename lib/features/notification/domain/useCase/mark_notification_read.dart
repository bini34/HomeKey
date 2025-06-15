import "package:MediTrack/features/notification/domain/entity/notification.dart";
import "package:MediTrack/features/notification/domain/repositories/notification_repository.dart";

class MarkNotificationRead {
  final NotificationRepository repository;

  MarkNotificationRead(this.repository);

  Future<void> call(Notification notification) async {
    return await repository.updateNotification(
      notification.copyWith(isRead: true),
    );
  }
}
