import "package:MediTrack/features/medication/domain/repositories/medication_repository.dart";

class DeleteMedication {
  final MedicationRepository repository;

  DeleteMedication(this.repository);

  Future<void> call(String medicationId) async {
    return await repository.deleteMedication(medicationId);
  }
}
