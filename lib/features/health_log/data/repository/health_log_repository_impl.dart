import "package:MediTrack/features/health_log/data/data_sources/local/hive_health_log_data_source.dart";
import "package:MediTrack/features/health_log/data/data_sources/remote/firebase_health_log_data_source.dart";
import "package:MediTrack/features/health_log/data/models/health_log_model.dart";
import "package:MediTrack/features/health_log/domain/entity/health_log.dart";
import "package:MediTrack/features/health_log/domain/repositories/health_log_repository.dart";

class HealthLogRepositoryImpl implements HealthLogRepository {
  final HealthLogLocalDataSource localDataSource;
  final HealthLogRemoteDataSource remoteDataSource;

  HealthLogRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<HealthLog> createHealthLog(HealthLog healthLog) async {
    final healthLogModel = HealthLogModel.fromEntity(healthLog);
    await localDataSource.saveHealthLog(healthLogModel);
    await remoteDataSource.createHealthLog(healthLogModel);
    return healthLog;
  }

  @override
  Future<HealthLog?> getHealthLog(String logId) async {
    HealthLogModel? healthLog = await localDataSource.getHealthLog(logId);
    if (healthLog != null) {
      return healthLog;
    }
    healthLog = await remoteDataSource.getHealthLog(logId);
    if (healthLog != null) {
      await localDataSource.saveHealthLog(healthLog);
    }
    return healthLog;
  }

  @override
  Future<List<HealthLog>> getAllHealthLogs(String userId) async {
    final remoteHealthLogs = await remoteDataSource.getAllHealthLogs(userId);
    for (var healthLog in remoteHealthLogs) {
      await localDataSource.saveHealthLog(healthLog);
    }
    return remoteHealthLogs;
  }

  @override
  Future<void> updateHealthLog(HealthLog healthLog) async {
    final healthLogModel = HealthLogModel.fromEntity(healthLog);
    await localDataSource.saveHealthLog(healthLogModel);
    await remoteDataSource.updateHealthLog(healthLogModel);
  }

  @override
  Future<void> deleteHealthLog(String logId) async {
    await localDataSource.deleteHealthLog(logId);
    await remoteDataSource.deleteHealthLog(logId);
  }
}
