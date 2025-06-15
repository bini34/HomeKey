import 'package:equatable/equatable.dart';

enum AppointmentStatus {
  scheduled,
  completed,
  cancelled,
}

class Appointment extends Equatable {
  final String appointmentId;
  final String userId;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final String location;
  final String? notes;
  final AppointmentStatus status;

  const Appointment({
    required this.appointmentId,
    required this.userId,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.location,
    this.notes,
    required this.status,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        userId,
        doctorName,
        specialty,
        dateTime,
        location,
        notes,
        status,
      ];

  Appointment copyWith({
    String? appointmentId,
    String? userId,
    String? doctorName,
    String? specialty,
    DateTime? dateTime,
    String? location,
    String? notes,
    AppointmentStatus? status,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      userId: userId ?? this.userId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}


