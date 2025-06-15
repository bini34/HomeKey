import "package:MediTrack/features/notification/data/data_sources/local/hive_notification_data_source.dart";
import "package:MediTrack/features/notification/data/data_sources/remote/firebase_notification_data_source.dart";
import "package:MediTrack/features/notification/data/models/notification_model.dart";
import "package:MediTrack/features/notification/domain/entity/notification.dart";
import "package:MediTrack/features/notification/domain/repositories/notification_repository.dart";

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Notification> createNotification(Notification notification) async {
    final notificationModel = NotificationModel.fromEntity(notification);
    await localDataSource.saveNotification(notificationModel);
    await remoteDataSource.createNotification(notificationModel);
    return notification;
  }

  @override
  Future<Notification?> getNotification(String notificationId) async {
    NotificationModel? notification = await localDataSource.getNotification(
      notificationId,
    );
    if (notification != null) {
      return notification;
    }
    notification = await remoteDataSource.getNotification(notificationId);
    if (notification != null) {
      await localDataSource.saveNotification(notification);
    }
    return notification;
  }

  @override
  Future<List<Notification>> getAllNotifications(String userId) async {
    final remoteNotifications = await remoteDataSource.getAllNotifications(
      userId,
    );
    for (var notification in remoteNotifications) {
      await localDataSource.saveNotification(notification);
    }
    return remoteNotifications;
  }

  @override
  Future<void> updateNotification(Notification notification) async {
    final notificationModel = NotificationModel.fromEntity(notification);
    await localDataSource.saveNotification(notificationModel);
    await remoteDataSource.updateNotification(notificationModel);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await localDataSource.deleteNotification(notificationId);
    await remoteDataSource.deleteNotification(notificationId);
  }
}
