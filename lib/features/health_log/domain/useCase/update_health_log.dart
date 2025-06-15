import "package:MediTrack/features/health_log/domain/entity/health_log.dart";
import "package:MediTrack/features/health_log/domain/repositories/health_log_repository.dart";

class UpdateHealthLog {
  final HealthLogRepository repository;

  UpdateHealthLog(this.repository);

  Future<void> call(HealthLog healthLog) async {
    return await repository.updateHealthLog(healthLog);
  }
}
