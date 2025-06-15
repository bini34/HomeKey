
import 'package:hive/hive.dart';
import '../models/health_log_model.dart';

abstract class HealthLogLocalDataSource {
  Future<void> saveHealthLog(HealthLogModel healthLog);
  Future<HealthLogModel?> getHealthLog(String logId);
  Future<List<HealthLogModel>> getAllHealthLogs();
  Future<void> deleteHealthLog(String logId);
}

class HiveHealthLogDataSource implements HealthLogLocalDataSource {
  static const String _healthLogBoxName = 'healthLogBox';

  @override
  Future<void> saveHealthLog(HealthLogModel healthLog) async {
    final box = await Hive.openBox<HealthLogModel>(_healthLogBoxName);
    await box.put(healthLog.logId, healthLog);
  }

  @override
  Future<HealthLogModel?> getHealthLog(String logId) async {
    final box = await Hive.openBox<HealthLogModel>(_healthLogBoxName);
    return box.get(logId);
  }

  @override
  Future<List<HealthLogModel>> getAllHealthLogs() async {
    final box = await Hive.openBox<HealthLogModel>(_healthLogBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteHealthLog(String logId) async {
    final box = await Hive.openBox<HealthLogModel>(_healthLogBoxName);
    await box.delete(logId);
  }
}


