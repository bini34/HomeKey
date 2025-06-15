// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 3;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel();
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) =>
    ReminderModel(
      reminderId: json['reminderId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
      relatedId: json['relatedId'] as String,
      time: DateTime.parse(json['time'] as String),
      message: json['message'] as String,
      isActive: json['isActive'] as bool,
      repeat: $enumDecode(_$RepeatTypeEnumMap, json['repeat']),
    );

Map<String, dynamic> _$ReminderModelToJson(ReminderModel instance) =>
    <String, dynamic>{
      'reminderId': instance.reminderId,
      'userId': instance.userId,
      'type': _$ReminderTypeEnumMap[instance.type]!,
      'relatedId': instance.relatedId,
      'time': instance.time.toIso8601String(),
      'message': instance.message,
      'isActive': instance.isActive,
      'repeat': _$RepeatTypeEnumMap[instance.repeat]!,
    };

const _$ReminderTypeEnumMap = {
  ReminderType.medication: 'medication',
  ReminderType.appointment: 'appointment',
};

const _$RepeatTypeEnumMap = {
  RepeatType.none: 'none',
  RepeatType.daily: 'daily',
  RepeatType.weekly: 'weekly',
};
