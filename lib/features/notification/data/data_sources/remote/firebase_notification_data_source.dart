
import "package:cloud_firestore/cloud_firestore.dart";
import "../../models/notification_model.dart";

abstract class NotificationRemoteDataSource {
  Future<NotificationModel> createNotification(NotificationModel notification);
  Future<NotificationModel?> getNotification(String notificationId);
  Future<List<NotificationModel>> getAllNotifications(String userId);
  Future<void> updateNotification(NotificationModel notification);
  Future<void> deleteNotification(String notificationId);
}

class FirebaseNotificationDataSource implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<NotificationModel> createNotification(NotificationModel notification) async {
    await _firestore.collection("notifications").doc(notification.notificationId).set(notification.toJson());
    return notification;
  }

  @override
  Future<NotificationModel?> getNotification(String notificationId) async {
    final doc = await _firestore.collection("notifications").doc(notificationId).get();
    if (doc.exists) {
      return NotificationModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<NotificationModel>> getAllNotifications(String userId) async {
    final querySnapshot = await _firestore.collection("notifications").where("userId", isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateNotification(NotificationModel notification) async {
    await _firestore.collection("notifications").doc(notification.notificationId).update(notification.toJson());
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection("notifications").doc(notificationId).delete();
  }
}


