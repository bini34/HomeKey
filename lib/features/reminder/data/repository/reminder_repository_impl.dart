import "package:MediTrack/features/reminder/data/data_sources/local/hive_reminder_data_source.dart";
import "package:MediTrack/features/reminder/data/data_sources/remote/firebase_reminder_data_source.dart";
import "package:MediTrack/features/reminder/data/models/reminder_model.dart";
import "package:MediTrack/features/reminder/domain/entity/reminder.dart";
import "package:MediTrack/features/reminder/domain/repositories/reminder_repository.dart";

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;
  final ReminderRemoteDataSource remoteDataSource;

  ReminderRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Reminder> createReminder(Reminder reminder) async {
    final reminderModel = ReminderModel.fromEntity(reminder);
    await localDataSource.saveReminder(reminderModel);
    await remoteDataSource.createReminder(reminderModel);
    return reminder;
  }

  @override
  Future<Reminder?> getReminder(String reminderId) async {
    ReminderModel? reminder = await localDataSource.getReminder(reminderId);
    if (reminder != null) {
      return reminder;
    }
    reminder = await remoteDataSource.getReminder(reminderId);
    if (reminder != null) {
      await localDataSource.saveReminder(reminder);
    }
    return reminder;
  }

  @override
  Future<List<Reminder>> getAllReminders(String userId) async {
    final remoteReminders = await remoteDataSource.getAllReminders(userId);
    for (var reminder in remoteReminders) {
      await localDataSource.saveReminder(reminder);
    }
    return remoteReminders;
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final reminderModel = ReminderModel.fromEntity(reminder);
    await localDataSource.saveReminder(reminderModel);
    await remoteDataSource.updateReminder(reminderModel);
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    await localDataSource.deleteReminder(reminderId);
    await remoteDataSource.deleteReminder(reminderId);
  }
}
