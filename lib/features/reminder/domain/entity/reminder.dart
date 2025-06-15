import 'package:equatable/equatable.dart';

enum ReminderType {
  medication,
  appointment,
}

enum RepeatType {
  none,
  daily,
  weekly,
}

class Reminder extends Equatable {
  final String reminderId;
  final String userId;
  final ReminderType type;
  final String relatedId;
  final DateTime time;
  final String message;
  final bool isActive;
  final RepeatType repeat;

  const Reminder({
    required this.reminderId,
    required this.userId,
    required this.type,
    required this.relatedId,
    required this.time,
    required this.message,
    required this.isActive,
    required this.repeat,
  });

  @override
  List<Object?> get props => [
        reminderId,
        userId,
        type,
        relatedId,
        time,
        message,
        isActive,
        repeat,
      ];

  Reminder copyWith({
    String? reminderId,
    String? userId,
    ReminderType? type,
    String? relatedId,
    DateTime? time,
    String? message,
    bool? isActive,
    RepeatType? repeat,
  }) {
    return Reminder(
      reminderId: reminderId ?? this.reminderId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      time: time ?? this.time,
      message: message ?? this.message,
      isActive: isActive ?? this.isActive,
      repeat: repeat ?? this.repeat,
    );
  }
}


