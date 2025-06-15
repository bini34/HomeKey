
import 'package:hive/hive.dart';
import '../../models/medication_model.dart';

abstract class MedicationLocalDataSource {
  Future<void> saveMedication(MedicationModel medication);
  Future<MedicationModel?> getMedication(String medicationId);
  Future<List<MedicationModel>> getAllMedications();
  Future<void> deleteMedication(String medicationId);
}

class HiveMedicationDataSource implements MedicationLocalDataSource {
  static const String _medicationBoxName = 'medicationBox';

  @override
  Future<void> saveMedication(MedicationModel medication) async {
    final box = await Hive.openBox<MedicationModel>(_medicationBoxName);
    await box.put(medication.medicationId, medication);
  }

  @override
  Future<MedicationModel?> getMedication(String medicationId) async {
    final box = await Hive.openBox<MedicationModel>(_medicationBoxName);
    return box.get(medicationId);
  }

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    final box = await Hive.openBox<MedicationModel>(_medicationBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteMedication(String medicationId) async {
    final box = await Hive.openBox<MedicationModel>(_medicationBoxName);
    await box.delete(medicationId);
  }
}


