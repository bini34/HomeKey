
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> createAppointment(AppointmentModel appointment);
  Future<AppointmentModel?> getAppointment(String appointmentId);
  Future<List<AppointmentModel>> getAllAppointments(String userId);
  Future<void> updateAppointment(AppointmentModel appointment);
  Future<void> deleteAppointment(String appointmentId);
}

class FirebaseAppointmentDataSource implements AppointmentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppointmentModel> createAppointment(AppointmentModel appointment) async {
    await _firestore.collection('appointments').doc(appointment.appointmentId).set(appointment.toJson());
    return appointment;
  }

  @override
  Future<AppointmentModel?> getAppointment(String appointmentId) async {
    final doc = await _firestore.collection('appointments').doc(appointmentId).get();
    if (doc.exists) {
      return AppointmentModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<AppointmentModel>> getAllAppointments(String userId) async {
    final querySnapshot = await _firestore.collection('appointments').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => AppointmentModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    await _firestore.collection('appointments').doc(appointment.appointmentId).update(appointment.toJson());
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }
}


