// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentModelAdapter extends TypeAdapter<AppointmentModel> {
  @override
  final int typeId = 2;

  @override
  AppointmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentModel();
  }

  @override
  void write(BinaryWriter writer, AppointmentModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      appointmentId: json['appointmentId'] as String,
      userId: json['userId'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      notes: json['notes'] as String?,
      status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'userId': instance.userId,
      'doctorName': instance.doctorName,
      'specialty': instance.specialty,
      'dateTime': instance.dateTime.toIso8601String(),
      'location': instance.location,
      'notes': instance.notes,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
};
