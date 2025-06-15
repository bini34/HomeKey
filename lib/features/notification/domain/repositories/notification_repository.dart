
import "../../domain/entity/notification.dart";

abstract class NotificationRepository {
  Future<Notification> createNotification(Notification notification);
  Future<Notification?> getNotification(String notificationId);
  Future<List<Notification>> getAllNotifications(String userId);
  Future<void> updateNotification(Notification notification);
  Future<void> deleteNotification(String notificationId);
}


