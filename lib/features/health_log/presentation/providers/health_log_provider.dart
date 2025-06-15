import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/health_log/data/data_sources/local/hive_health_log_data_source.dart";
import "package:MediTrack/features/health_log/data/data_sources/remote/firebase_health_log_data_source.dart";
import "package:MediTrack/features/health_log/data/repository/health_log_repository_impl.dart";
import "package:MediTrack/features/health_log/domain/entity/health_log.dart";
import "package:MediTrack/features/health_log/domain/useCase/add_health_log.dart";
import "package:MediTrack/features/health_log/domain/useCase/delete_health_log.dart";
import "package:MediTrack/features/health_log/domain/useCase/update_health_log.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

final healthLogLocalDataSourceProvider = Provider<HealthLogLocalDataSource>(
  (ref) => HiveHealthLogDataSource(),
);

final healthLogRemoteDataSourceProvider = Provider<HealthLogRemoteDataSource>(
  (ref) => FirebaseHealthLogDataSource(),
);

final healthLogRepositoryProvider = Provider<HealthLogRepositoryImpl>(
  (ref) => HealthLogRepositoryImpl(
    localDataSource: ref.read(healthLogLocalDataSourceProvider),
    remoteDataSource: ref.read(healthLogRemoteDataSourceProvider),
  ),
);

final addHealthLogUseCaseProvider = Provider<AddHealthLog>(
  (ref) => AddHealthLog(ref.read(healthLogRepositoryProvider)),
);

final updateHealthLogUseCaseProvider = Provider<UpdateHealthLog>(
  (ref) => UpdateHealthLog(ref.read(healthLogRepositoryProvider)),
);

final deleteHealthLogUseCaseProvider = Provider<DeleteHealthLog>(
  (ref) => DeleteHealthLog(ref.read(healthLogRepositoryProvider)),
);

final healthLogListProvider =
    StateNotifierProvider<HealthLogNotifier, AsyncValue<List<HealthLog>>>((
      ref,
    ) {
      final userId = ref.watch(userProvider)?.userId;
      if (userId == null) {
        return const AsyncValue.data([]);
      }
      return HealthLogNotifier(ref.read(healthLogRepositoryProvider), userId);
    });

class HealthLogNotifier extends StateNotifier<AsyncValue<List<HealthLog>>> {
  final HealthLogRepositoryImpl _healthLogRepository;
  final String _userId;

  HealthLogNotifier(this._healthLogRepository, this._userId)
    : super(const AsyncValue.loading()) {
    _fetchHealthLogs();
  }

  Future<void> _fetchHealthLogs() async {
    try {
      state = const AsyncValue.loading();
      final healthLogs = await _healthLogRepository.getAllHealthLogs(_userId);
      state = AsyncValue.data(healthLogs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHealthLog(HealthLog healthLog) async {
    try {
      await _healthLogRepository.createHealthLog(healthLog);
      await _fetchHealthLogs(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateHealthLog(HealthLog healthLog) async {
    try {
      await _healthLogRepository.updateHealthLog(healthLog);
      await _fetchHealthLogs(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteHealthLog(String logId) async {
    try {
      await _healthLogRepository.deleteHealthLog(logId);
      await _fetchHealthLogs(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
