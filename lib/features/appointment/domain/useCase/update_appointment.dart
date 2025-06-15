import "package:MediTrack/features/appointment/domain/entity/appointment.dart";
import "package:MediTrack/features/appointment/domain/repositories/appointment_repository.dart";

class UpdateAppointment {
  final AppointmentRepository repository;

  UpdateAppointment(this.repository);

  Future<void> call(Appointment appointment) async {
    return await repository.updateAppointment(appointment);
  }
}
