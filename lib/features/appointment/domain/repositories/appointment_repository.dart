
import "../../domain/entity/appointment.dart";

abstract class AppointmentRepository {
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment?> getAppointment(String appointmentId);
  Future<List<Appointment>> getAllAppointments(String userId);
  Future<void> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(String appointmentId);
}


