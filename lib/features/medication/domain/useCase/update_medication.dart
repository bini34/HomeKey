import "package:MediTrack/features/medication/domain/entity/medication.dart";
import "package:MediTrack/features/medication/domain/repositories/medication_repository.dart";

class UpdateMedication {
  final MedicationRepository repository;

  UpdateMedication(this.repository);

  Future<void> call(Medication medication) async {
    return await repository.updateMedication(medication);
  }
}
