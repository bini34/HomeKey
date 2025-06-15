import "package:MediTrack/features/appointment/domain/entity/appointment.dart";
import "package:MediTrack/features/appointment/domain/repositories/appointment_repository.dart";

class AddAppointment {
  final AppointmentRepository repository;

  AddAppointment(this.repository);

  Future<Appointment> call(Appointment appointment) async {
    return await repository.createAppointment(appointment);
  }
}
