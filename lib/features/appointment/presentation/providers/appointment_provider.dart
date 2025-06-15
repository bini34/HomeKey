import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/appointment/data/data_sources/local/hive_appointment_data_source.dart";
import "package:MediTrack/features/appointment/data/data_sources/remote/firebase_appointment_data_source.dart";
import "package:MediTrack/features/appointment/data/repository/appointment_repository_impl.dart";
import "package:MediTrack/features/appointment/domain/entity/appointment.dart";
import "package:MediTrack/features/appointment/domain/useCase/add_appointment.dart";
import "package:MediTrack/features/appointment/domain/useCase/delete_appointment.dart";
import "package:MediTrack/features/appointment/domain/useCase/update_appointment.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

final appointmentLocalDataSourceProvider = Provider<AppointmentLocalDataSource>(
  (ref) => HiveAppointmentDataSource(),
);

final appointmentRemoteDataSourceProvider =
    Provider<AppointmentRemoteDataSource>(
      (ref) => FirebaseAppointmentDataSource(),
    );

final appointmentRepositoryProvider = Provider<AppointmentRepositoryImpl>(
  (ref) => AppointmentRepositoryImpl(
    localDataSource: ref.read(appointmentLocalDataSourceProvider),
    remoteDataSource: ref.read(appointmentRemoteDataSourceProvider),
  ),
);

final addAppointmentUseCaseProvider = Provider<AddAppointment>(
  (ref) => AddAppointment(ref.read(appointmentRepositoryProvider)),
);

final updateAppointmentUseCaseProvider = Provider<UpdateAppointment>(
  (ref) => UpdateAppointment(ref.read(appointmentRepositoryProvider)),
);

final deleteAppointmentUseCaseProvider = Provider<DeleteAppointment>(
  (ref) => DeleteAppointment(ref.read(appointmentRepositoryProvider)),
);

final appointmentListProvider = StateNotifierProvider<
  AppointmentNotifier,
  AsyncValue<List<Appointment>>
>((ref) {
  final userId = ref.watch(userProvider)?.userId ?? '';

  return AppointmentNotifier(ref.read(appointmentRepositoryProvider), userId);
});

class AppointmentNotifier extends StateNotifier<AsyncValue<List<Appointment>>> {
  final AppointmentRepositoryImpl _appointmentRepository;
  final String _userId;

  AppointmentNotifier(this._appointmentRepository, this._userId)
    : super(const AsyncValue.loading()) {
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      state = const AsyncValue.loading();
      final appointments = await _appointmentRepository.getAllAppointments(
        _userId,
      );
      state = AsyncValue.data(appointments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _appointmentRepository.createAppointment(appointment);
      await _fetchAppointments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _appointmentRepository.updateAppointment(appointment);
      await _fetchAppointments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _appointmentRepository.deleteAppointment(appointmentId);
      await _fetchAppointments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
