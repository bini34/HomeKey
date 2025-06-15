import "package:MediTrack/features/notification/domain/entity/notification.dart";
import "package:MediTrack/features/notification/domain/repositories/notification_repository.dart";

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<Notification>> call(String userId) async {
    return await repository.getAllNotifications(userId);
  }
}
