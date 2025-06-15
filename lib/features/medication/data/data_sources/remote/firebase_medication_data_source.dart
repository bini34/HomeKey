
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/medication_model.dart';

abstract class MedicationRemoteDataSource {
  Future<MedicationModel> createMedication(MedicationModel medication);
  Future<MedicationModel?> getMedication(String medicationId);
  Future<List<MedicationModel>> getAllMedications(String userId);
  Future<void> updateMedication(MedicationModel medication);
  Future<void> deleteMedication(String medicationId);
}

class FirebaseMedicationDataSource implements MedicationRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<MedicationModel> createMedication(MedicationModel medication) async {
    await _firestore.collection('medications').doc(medication.medicationId).set(medication.toJson());
    return medication;
  }

  @override
  Future<MedicationModel?> getMedication(String medicationId) async {
    final doc = await _firestore.collection('medications').doc(medicationId).get();
    if (doc.exists) {
      return MedicationModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<MedicationModel>> getAllMedications(String userId) async {
    final querySnapshot = await _firestore.collection('medications').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => MedicationModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateMedication(MedicationModel medication) async {
    await _firestore.collection('medications').doc(medication.medicationId).update(medication.toJson());
  }

  @override
  Future<void> deleteMedication(String medicationId) async {
    await _firestore.collection('medications').doc(medicationId).delete();
  }
}


