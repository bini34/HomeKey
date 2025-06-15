import "package:MediTrack/features/reminder/domain/repositories/reminder_repository.dart";

class DeleteReminder {
  final ReminderRepository repository;

  DeleteReminder(this.repository);

  Future<void> call(String reminderId) async {
    return await repository.deleteReminder(reminderId);
  }
}
