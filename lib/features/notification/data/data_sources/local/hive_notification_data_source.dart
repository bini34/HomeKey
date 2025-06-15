
import 'package:hive/hive.dart';
import '../../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<void> saveNotification(NotificationModel notification);
  Future<NotificationModel?> getNotification(String notificationId);
  Future<List<NotificationModel>> getAllNotifications();
  Future<void> deleteNotification(String notificationId);
}

class HiveNotificationDataSource implements NotificationLocalDataSource {
  static const String _notificationBoxName = 'notificationBox';

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    final box = await Hive.openBox<NotificationModel>(_notificationBoxName);
    await box.put(notification.notificationId, notification);
  }

  @override
  Future<NotificationModel?> getNotification(String notificationId) async {
    final box = await Hive.openBox<NotificationModel>(_notificationBoxName);
    return box.get(notificationId);
  }

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    final box = await Hive.openBox<NotificationModel>(_notificationBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final box = await Hive.openBox<NotificationModel>(_notificationBoxName);
    await box.delete(notificationId);
  }
}


