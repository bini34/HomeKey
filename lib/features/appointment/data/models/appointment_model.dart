
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/appointment.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 2) // Use a different typeId for AppointmentModel
@JsonSerializable()
class AppointmentModel extends Appointment {
  const AppointmentModel({
    @HiveField(0) required String appointmentId,
    @HiveField(1) required String userId,
    @HiveField(2) required String doctorName,
    @HiveField(3) required String specialty,
    @HiveField(4) required DateTime dateTime,
    @HiveField(5) required String location,
    @HiveField(6) String? notes,
    @HiveField(7) required AppointmentStatus status,
  }) : super(
          appointmentId: appointmentId,
          userId: userId,
          doctorName: doctorName,
          specialty: specialty,
          dateTime: dateTime,
          location: location,
          notes: notes,
          status: status,
        );

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      appointmentId: appointment.appointmentId,
      userId: appointment.userId,
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      dateTime: appointment.dateTime,
      location: appointment.location,
      notes: appointment.notes,
      status: appointment.status,
    );
  }
}

class AppointmentStatusConverter implements JsonConverter<AppointmentStatus, String> {
  const AppointmentStatusConverter();

  @override
  AppointmentStatus fromJson(String json) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => AppointmentStatus.scheduled, // Default value
    );
  }

  @override
  String toJson(AppointmentStatus object) {
    return object.toString().split('.').last;
  }
}


