import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:MediTrack/features/reminder/data/data_sources/local/hive_reminder_data_source.dart";
import "package:MediTrack/features/reminder/data/data_sources/remote/firebase_reminder_data_source.dart";
import "package:MediTrack/features/reminder/data/repository/reminder_repository_impl.dart";
import "package:MediTrack/features/reminder/domain/entity/reminder.dart";
import "package:MediTrack/features/reminder/domain/useCase/add_reminder.dart";
import "package:MediTrack/features/reminder/domain/useCase/delete_reminder.dart";
import "package:MediTrack/features/reminder/domain/useCase/update_reminder.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

final reminderLocalDataSourceProvider = Provider<ReminderLocalDataSource>(
  (ref) => HiveReminderDataSource(),
);

final reminderRemoteDataSourceProvider = Provider<ReminderRemoteDataSource>(
  (ref) => FirebaseReminderDataSource(),
);

final reminderRepositoryProvider = Provider<ReminderRepositoryImpl>(
  (ref) => ReminderRepositoryImpl(
    localDataSource: ref.read(reminderLocalDataSourceProvider),
    remoteDataSource: ref.read(reminderRemoteDataSourceProvider),
  ),
);

final addReminderUseCaseProvider = Provider<AddReminder>(
  (ref) => AddReminder(ref.read(reminderRepositoryProvider)),
);

final updateReminderUseCaseProvider = Provider<UpdateReminder>(
  (ref) => UpdateReminder(ref.read(reminderRepositoryProvider)),
);

final deleteReminderUseCaseProvider = Provider<DeleteReminder>(
  (ref) => DeleteReminder(ref.read(reminderRepositoryProvider)),
);

final reminderListProvider =
    StateNotifierProvider<ReminderNotifier, AsyncValue<List<Reminder>>>((ref) {
      final userId = ref.watch(userProvider)?.userId ?? '';

      return ReminderNotifier(ref.read(reminderRepositoryProvider), userId);
    });

class ReminderNotifier extends StateNotifier<AsyncValue<List<Reminder>>> {
  final ReminderRepositoryImpl _reminderRepository;
  final String _userId;

  ReminderNotifier(this._reminderRepository, this._userId)
    : super(const AsyncValue.loading()) {
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    try {
      state = const AsyncValue.loading();
      final reminders = await _reminderRepository.getAllReminders(_userId);
      state = AsyncValue.data(reminders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    try {
      await _reminderRepository.createReminder(reminder);
      await _fetchReminders(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _reminderRepository.updateReminder(reminder);
      await _fetchReminders(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _reminderRepository.deleteReminder(reminderId);
      await _fetchReminders(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
