import "package:MediTrack/features/health_log/domain/repositories/health_log_repository.dart";

class DeleteHealthLog {
  final HealthLogRepository repository;

  DeleteHealthLog(this.repository);

  Future<void> call(String logId) async {
    return await repository.deleteHealthLog(logId);
  }
}
