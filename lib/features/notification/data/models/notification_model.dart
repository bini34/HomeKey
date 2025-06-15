
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/notification.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 6) // Use a different typeId for NotificationModel
@JsonSerializable()
class NotificationModel extends Notification {
  const NotificationModel({
    @HiveField(0) required String notificationId,
    @HiveField(1) required String userId,
    @HiveField(2) required String title,
    @HiveField(3) required String message,
    @HiveField(4) @NotificationTypeConverter() required NotificationType type,
    @HiveField(5) required DateTime timestamp,
    @HiveField(6) required bool isRead,
  }) : super(
          notificationId: notificationId,
          userId: userId,
          title: title,
          message: message,
          type: type,
          timestamp: timestamp,
          isRead: isRead,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromEntity(Notification notification) {
    return NotificationModel(
      notificationId: notification.notificationId,
      userId: notification.userId,
      title: notification.title,
      message: notification.message,
      type: notification.type,
      timestamp: notification.timestamp,
      isRead: notification.isRead,
    );
  }
}

class NotificationTypeConverter implements JsonConverter<NotificationType, String> {
  const NotificationTypeConverter();

  @override
  NotificationType fromJson(String json) {
    return NotificationType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => NotificationType.general, // Default value
    );
  }

  @override
  String toJson(NotificationType object) {
    return object.toString().split('.').last;
  }
}


