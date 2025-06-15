
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/reminder.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 3) // Use a different typeId for ReminderModel
@JsonSerializable()
class ReminderModel extends Reminder {
  const ReminderModel({
    @HiveField(0) required String reminderId,
    @HiveField(1) required String userId,
    @HiveField(2) @ReminderTypeConverter() required ReminderType type,
    @HiveField(3) required String relatedId,
    @HiveField(4) required DateTime time,
    @HiveField(5) required String message,
    @HiveField(6) required bool isActive,
    @HiveField(7) @RepeatTypeConverter() required RepeatType repeat,
  }) : super(
          reminderId: reminderId,
          userId: userId,
          type: type,
          relatedId: relatedId,
          time: time,
          message: message,
          isActive: isActive,
          repeat: repeat,
        );

  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      reminderId: reminder.reminderId,
      userId: reminder.userId,
      type: reminder.type,
      relatedId: reminder.relatedId,
      time: reminder.time,
      message: reminder.message,
      isActive: reminder.isActive,
      repeat: reminder.repeat,
    );
  }
}

class ReminderTypeConverter implements JsonConverter<ReminderType, String> {
  const ReminderTypeConverter();

  @override
  ReminderType fromJson(String json) {
    return ReminderType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => ReminderType.medication, // Default value
    );
  }

  @override
  String toJson(ReminderType object) {
    return object.toString().split('.').last;
  }
}

class RepeatTypeConverter implements JsonConverter<RepeatType, String> {
  const RepeatTypeConverter();

  @override
  RepeatType fromJson(String json) {
    return RepeatType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => RepeatType.none, // Default value
    );
  }

  @override
  String toJson(RepeatType object) {
    return object.toString().split('.').last;
  }
}


