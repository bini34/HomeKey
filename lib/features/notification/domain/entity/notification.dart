import 'package:equatable/equatable.dart';

enum NotificationType {
  reminder,
  stockAlert,
  general,
}

class Notification extends Equatable {
  final String notificationId;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const Notification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
        notificationId,
        userId,
        title,
        message,
        type,
        timestamp,
        isRead,
      ];

  Notification copyWith({
    String? notificationId,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Notification(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}


