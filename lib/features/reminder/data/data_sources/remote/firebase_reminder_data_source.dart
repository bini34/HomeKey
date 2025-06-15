
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  Future<ReminderModel> createReminder(ReminderModel reminder);
  Future<ReminderModel?> getReminder(String reminderId);
  Future<List<ReminderModel>> getAllReminders(String userId);
  Future<void> updateReminder(ReminderModel reminder);
  Future<void> deleteReminder(String reminderId);
}

class FirebaseReminderDataSource implements ReminderRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    await _firestore.collection('reminders').doc(reminder.reminderId).set(reminder.toJson());
    return reminder;
  }

  @override
  Future<ReminderModel?> getReminder(String reminderId) async {
    final doc = await _firestore.collection('reminders').doc(reminderId).get();
    if (doc.exists) {
      return ReminderModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<List<ReminderModel>> getAllReminders(String userId) async {
    final querySnapshot = await _firestore.collection('reminders').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => ReminderModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> updateReminder(ReminderModel reminder) async {
    await _firestore.collection('reminders').doc(reminder.reminderId).update(reminder.toJson());
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    await _firestore.collection('reminders').doc(reminderId).delete();
  }
}


