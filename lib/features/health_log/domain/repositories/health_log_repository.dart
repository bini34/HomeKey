
import "../../domain/entity/health_log.dart";

abstract class HealthLogRepository {
  Future<HealthLog> createHealthLog(HealthLog healthLog);
  Future<HealthLog?> getHealthLog(String logId);
  Future<List<HealthLog>> getAllHealthLogs(String userId);
  Future<void> updateHealthLog(HealthLog healthLog);
  Future<void> deleteHealthLog(String logId);
}


