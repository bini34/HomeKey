
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/health_log.dart';

part 'health_log_model.g.dart';

@HiveType(typeId: 4) // Use a different typeId for HealthLogModel
@JsonSerializable()
class HealthLogModel extends HealthLog {
  const HealthLogModel({
    @HiveField(0) required String logId,
    @HiveField(1) required String userId,
    @HiveField(2) @HealthLogTypeConverter() required HealthLogType type,
    @HiveField(3) required String value,
    @HiveField(4) required DateTime dateTime,
    @HiveField(5) String? notes,
  }) : super(
          logId: logId,
          userId: userId,
          type: type,
          value: value,
          dateTime: dateTime,
          notes: notes,
        );

  factory HealthLogModel.fromJson(Map<String, dynamic> json) =>
      _$HealthLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthLogModelToJson(this);

  factory HealthLogModel.fromEntity(HealthLog healthLog) {
    return HealthLogModel(
      logId: healthLog.logId,
      userId: healthLog.userId,
      type: healthLog.type,
      value: healthLog.value,
      dateTime: healthLog.dateTime,
      notes: healthLog.notes,
    );
  }
}

class HealthLogTypeConverter implements JsonConverter<HealthLogType, String> {
  const HealthLogTypeConverter();

  @override
  HealthLogType fromJson(String json) {
    return HealthLogType.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => HealthLogType.bloodPressure, // Default value
    );
  }

  @override
  String toJson(HealthLogType object) {
    return object.toString().split('.').last;
  }
}


