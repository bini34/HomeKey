class Reminder {
  final String id;
  final String title;
  final ReminderType type;
  final DateTime time;
  final RepeatCycle repeat;
  final String relatedId; // Medicine or Appointment
  final String note;

  const Reminder({
    required this.id,
    required this.title,
    required this.type,
    required this.time,
    required this.repeat,
    required this.relatedId,
    required this.note,
  });
}

enum ReminderType { medicine, appointment }

enum RepeatCycle { once, daily, weekly, custom }
