import "package:MediTrack/features/reminder/domain/entity/reminder.dart";
import "package:MediTrack/features/reminder/domain/repositories/reminder_repository.dart";

class AddReminder {
  final ReminderRepository repository;

  AddReminder(this.repository);

  Future<Reminder> call(Reminder reminder) async {
    return await repository.createReminder(reminder);
  }
}
