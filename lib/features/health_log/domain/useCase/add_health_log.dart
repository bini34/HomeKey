import "package:MediTrack/features/health_log/domain/entity/health_log.dart";
import "package:MediTrack/features/health_log/domain/repositories/health_log_repository.dart";

class AddHealthLog {
  final HealthLogRepository repository;

  AddHealthLog(this.repository);

  Future<HealthLog> call(HealthLog healthLog) async {
    return await repository.createHealthLog(healthLog);
  }
}
