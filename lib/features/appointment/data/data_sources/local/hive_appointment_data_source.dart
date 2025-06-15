
import 'package:hive/hive.dart';
import '../models/appointment_model.dart';

abstract class AppointmentLocalDataSource {
  Future<void> saveAppointment(AppointmentModel appointment);
  Future<AppointmentModel?> getAppointment(String appointmentId);
  Future<List<AppointmentModel>> getAllAppointments();
  Future<void> deleteAppointment(String appointmentId);
}

class HiveAppointmentDataSource implements AppointmentLocalDataSource {
  static const String _appointmentBoxName = 'appointmentBox';

  @override
  Future<void> saveAppointment(AppointmentModel appointment) async {
    final box = await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    await box.put(appointment.appointmentId, appointment);
  }

  @override
  Future<AppointmentModel?> getAppointment(String appointmentId) async {
    final box = await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    return box.get(appointmentId);
  }

  @override
  Future<List<AppointmentModel>> getAllAppointments() async {
    final box = await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    final box = await Hive.openBox<AppointmentModel>(_appointmentBoxName);
    await box.delete(appointmentId);
  }
}


