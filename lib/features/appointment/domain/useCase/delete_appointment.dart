import "package:MediTrack/features/appointment/domain/repositories/appointment_repository.dart";

class DeleteAppointment {
  final AppointmentRepository repository;

  DeleteAppointment(this.repository);

  Future<void> call(String appointmentId) async {
    return await repository.deleteAppointment(appointmentId);
  }
}
