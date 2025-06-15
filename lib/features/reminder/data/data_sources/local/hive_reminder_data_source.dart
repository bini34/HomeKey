
import 'package:hive/hive.dart';
import '../../models/reminder_model.dart';

abstract class ReminderLocalDataSource {
  Future<void> saveReminder(ReminderModel reminder);
  Future<ReminderModel?> getReminder(String reminderId);
  Future<List<ReminderModel>> getAllReminders();
  Future<void> deleteReminder(String reminderId);
}

class HiveReminderDataSource implements ReminderLocalDataSource {
  static const String _reminderBoxName = 'reminderBox';

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    final box = await Hive.openBox<ReminderModel>(_reminderBoxName);
    await box.put(reminder.reminderId, reminder);
  }

  @override
  Future<ReminderModel?> getReminder(String reminderId) async {
    final box = await Hive.openBox<ReminderModel>(_reminderBoxName);
    return box.get(reminderId);
  }

  @override
  Future<List<ReminderModel>> getAllReminders() async {
    final box = await Hive.openBox<ReminderModel>(_reminderBoxName);
    return box.values.toList();
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    final box = await Hive.openBox<ReminderModel>(_reminderBoxName);
    await box.delete(reminderId);
  }
}


