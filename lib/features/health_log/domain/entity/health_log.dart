import 'package:equatable/equatable.dart';

enum HealthLogType {
  bloodPressure,
  mood,
  symptom,
  weight,
  glucose,
  heartRate,
}

class HealthLog extends Equatable {
  final String logId;
  final String userId;
  final HealthLogType type;
  final String value;
  final DateTime dateTime;
  final String? notes;

  const HealthLog({
    required this.logId,
    required this.userId,
    required this.type,
    required this.value,
    required this.dateTime,
    this.notes,
  });

  @override
  List<Object?> get props => [
        logId,
        userId,
        type,
        value,
        dateTime,
        notes,
      ];

  HealthLog copyWith({
    String? logId,
    String? userId,
    HealthLogType? type,
    String? value,
    DateTime? dateTime,
    String? notes,
  }) {
    return HealthLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      value: value ?? this.value,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }
}


