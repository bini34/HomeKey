
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_log_model.dart';

abstract class HealthLogRemoteDataSource {
  Future<HealthLogModel> createHealthLog(HealthLogModel healthLog);
  Future<HealthLogModel?> getHealthLog(String logId);
  Future<List<HealthLogModel>> getAllHealthLogs(String userId);
  Future<void> updateHealthLog(HealthLogModel healthLog);
  Future<void> deleteHealthLog(String logId);
}

class FirebaseHealthLogDataSource implements HealthLogRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<HealthLogModel> createHealthLog(HealthLogModel healthLog) async {
    await _firestore.collection('healthLogs').doc(healthLog.logId).set(healthLog.toJson());
    return healthLog;
  }

  @override
  Future<HealthLogModel?> getHealthLog(String logId) async {
    final doc = await _firestore.collection('healthLogs').doc(logId).get();
    if (doc.exists) {
      return HealthLogModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<HealthLogModel>> getAllHealthLogs(String userId) async {
    final querySnapshot = await _firestore.collection('healthLogs').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => HealthLogModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateHealthLog(HealthLogModel healthLog) async {
    await _firestore.collection('healthLogs').doc(healthLog.logId).update(healthLog.toJson());
  }

  @override
  Future<void> deleteHealthLog(String logId) async {
    await _firestore.collection('healthLogs').doc(logId).delete();
  }
}


