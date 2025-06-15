import "package:MediTrack/features/appointment/data/data_sources/local/hive_appointment_data_source.dart";
import "package:MediTrack/features/appointment/data/data_sources/remote/firebase_appointment_data_source.dart";
import "package:MediTrack/features/appointment/data/models/appointment_model.dart";
import "package:MediTrack/features/appointment/domain/entity/appointment.dart";
import "package:MediTrack/features/appointment/domain/repositories/appointment_repository.dart";

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    final appointmentModel = AppointmentModel.fromEntity(appointment);
    await localDataSource.saveAppointment(appointmentModel);
    await remoteDataSource.createAppointment(appointmentModel);
    return appointment;
  }

  @override
  Future<Appointment?> getAppointment(String appointmentId) async {
    AppointmentModel? appointment = await localDataSource.getAppointment(
      appointmentId,
    );
    if (appointment != null) {
      return appointment;
    }
    appointment = await remoteDataSource.getAppointment(appointmentId);
    if (appointment != null) {
      await localDataSource.saveAppointment(appointment);
    }
    return appointment;
  }

  @override
  Future<List<Appointment>> getAllAppointments(String userId) async {
    final remoteAppointments = await remoteDataSource.getAllAppointments(
      userId,
    );
    for (var appointment in remoteAppointments) {
      await localDataSource.saveAppointment(appointment);
    }
    return remoteAppointments;
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    final appointmentModel = AppointmentModel.fromEntity(appointment);
    await localDataSource.saveAppointment(appointmentModel);
    await remoteDataSource.updateAppointment(appointmentModel);
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await localDataSource.deleteAppointment(appointmentId);
    await remoteDataSource.deleteAppointment(appointmentId);
  }
}
