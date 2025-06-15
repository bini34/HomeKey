import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/medication/data/data_sources/local/hive_medication_data_source.dart";
import "package:MediTrack/features/medication/data/data_sources/remote/firebase_medication_data_source.dart";
import "package:MediTrack/features/medication/data/repository/medication_repository_impl.dart";
import "package:MediTrack/features/medication/domain/entity/medication.dart";
import "package:MediTrack/features/medication/domain/useCase/add_medication.dart";
import "package:MediTrack/features/medication/domain/useCase/delete_medication.dart";
import "package:MediTrack/features/medication/domain/useCase/update_medication.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

final medicationLocalDataSourceProvider = Provider<MedicationLocalDataSource>(
  (ref) => HiveMedicationDataSource(),
);

final medicationRemoteDataSourceProvider = Provider<MedicationRemoteDataSource>(
  (ref) => FirebaseMedicationDataSource(),
);

final medicationRepositoryProvider = Provider<MedicationRepositoryImpl>(
  (ref) => MedicationRepositoryImpl(
    localDataSource: ref.read(medicationLocalDataSourceProvider),
    remoteDataSource: ref.read(medicationRemoteDataSourceProvider),
  ),
);

final addMedicationUseCaseProvider = Provider<AddMedication>(
  (ref) => AddMedication(ref.read(medicationRepositoryProvider)),
);

final updateMedicationUseCaseProvider = Provider<UpdateMedication>(
  (ref) => UpdateMedication(ref.read(medicationRepositoryProvider)),
);

final deleteMedicationUseCaseProvider = Provider<DeleteMedication>(
  (ref) => DeleteMedication(ref.read(medicationRepositoryProvider)),
);

final medicationListProvider =
    StateNotifierProvider<MedicationNotifier, AsyncValue<List<Medication>>>((
      ref,
    ) {
      final userId = ref.watch(userProvider)?.userId ?? '';

      return MedicationNotifier(ref.read(medicationRepositoryProvider), userId);
    });

class MedicationNotifier extends StateNotifier<AsyncValue<List<Medication>>> {
  final MedicationRepositoryImpl _medicationRepository;
  final String _userId;

  MedicationNotifier(this._medicationRepository, this._userId)
    : super(const AsyncValue.loading()) {
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    try {
      state = const AsyncValue.loading();
      final medications = await _medicationRepository.getAllMedications(
        _userId,
      );
      state = AsyncValue.data(medications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await _medicationRepository.createMedication(medication);
      await _fetchMedications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await _medicationRepository.updateMedication(medication);
      await _fetchMedications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    try {
      await _medicationRepository.deleteMedication(medicationId);
      await _fetchMedications(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
