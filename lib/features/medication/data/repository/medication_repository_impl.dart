import "package:MediTrack/features/medication/data/data_sources/local/hive_medication_data_source.dart";
import "package:MediTrack/features/medication/data/data_sources/remote/firebase_medication_data_source.dart";
import "package:MediTrack/features/medication/data/models/medication_model.dart";
import "package:MediTrack/features/medication/domain/entity/medication.dart";
import "package:MediTrack/features/medication/domain/repositories/medication_repository.dart";

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;
  final MedicationRemoteDataSource remoteDataSource;

  MedicationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Medication> createMedication(Medication medication) async {
    final medicationModel = MedicationModel.fromEntity(medication);
    await localDataSource.saveMedication(medicationModel);
    await remoteDataSource.createMedication(medicationModel);
    return medication;
  }

  @override
  Future<Medication?> getMedication(String medicationId) async {
    MedicationModel? medication = await localDataSource.getMedication(
      medicationId,
    );
    if (medication != null) {
      return medication;
    }
    medication = await remoteDataSource.getMedication(medicationId);
    if (medication != null) {
      await localDataSource.saveMedication(medication);
    }
    return medication;
  }

  @override
  Future<List<Medication>> getAllMedications(String userId) async {
    // For simplicity, we'll fetch from remote and update local. In a real app, you might have more complex sync logic.
    final remoteMedications = await remoteDataSource.getAllMedications(userId);
    for (var medication in remoteMedications) {
      await localDataSource.saveMedication(medication);
    }
    return remoteMedications;
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    final medicationModel = MedicationModel.fromEntity(medication);
    await localDataSource.saveMedication(medicationModel);
    await remoteDataSource.updateMedication(medicationModel);
  }

  @override
  Future<void> deleteMedication(String medicationId) async {
    await localDataSource.deleteMedication(medicationId);
    await remoteDataSource.deleteMedication(medicationId);
  }
}
