import "package:MediTrack/features/medication/domain/entity/medication.dart";
import "package:MediTrack/features/medication/domain/repositories/medication_repository.dart";

class AddMedication {
  final MedicationRepository repository;

  AddMedication(this.repository);

  Future<Medication> call(Medication medication) async {
    return await repository.createMedication(medication);
  }
}
