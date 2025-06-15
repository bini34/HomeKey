import "package:MediTrack/features/reminder/domain/entity/reminder.dart";
import "package:MediTrack/features/reminder/domain/repositories/reminder_repository.dart";

class UpdateReminder {
  final ReminderRepository repository;

  UpdateReminder(this.repository);

  Future<void> call(Reminder reminder) async {
    return await repository.updateReminder(reminder);
  }
}
