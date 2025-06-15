
import "../../domain/entity/medication.dart";

abstract class MedicationRepository {
  Future<Medication> createMedication(Medication medication);
  Future<Medication?> getMedication(String medicationId);
  Future<List<Medication>> getAllMedications(String userId);
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(String medicationId);
}


