
import "../../domain/entity/reminder.dart";

abstract class ReminderRepository {
  Future<Reminder> createReminder(Reminder reminder);
  Future<Reminder?> getReminder(String reminderId);
  Future<List<Reminder>> getAllReminders(String userId);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String reminderId);
}


