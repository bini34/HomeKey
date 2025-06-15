// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthLogModelAdapter extends TypeAdapter<HealthLogModel> {
  @override
  final int typeId = 4;

  @override
  HealthLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthLogModel();
  }

  @override
  void write(BinaryWriter writer, HealthLogModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthLogModel _$HealthLogModelFromJson(Map<String, dynamic> json) =>
    HealthLogModel(
      logId: json['logId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$HealthLogTypeEnumMap, json['type']),
      value: json['value'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$HealthLogModelToJson(HealthLogModel instance) =>
    <String, dynamic>{
      'logId': instance.logId,
      'userId': instance.userId,
      'type': _$HealthLogTypeEnumMap[instance.type]!,
      'value': instance.value,
      'dateTime': instance.dateTime.toIso8601String(),
      'notes': instance.notes,
    };

const _$HealthLogTypeEnumMap = {
  HealthLogType.bloodPressure: 'bloodPressure',
  HealthLogType.mood: 'mood',
  HealthLogType.symptom: 'symptom',
  HealthLogType.weight: 'weight',
  HealthLogType.glucose: 'glucose',
  HealthLogType.heartRate: 'heartRate',
};
