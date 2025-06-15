import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "package:MediTrack/features/reminder/domain/entity/reminder.dart";
import "package:MediTrack/features/reminder/presentation/providers/reminder_provider.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

class ReminderFormScreen extends ConsumerStatefulWidget {
  final String? reminderId;
  const ReminderFormScreen({super.key, this.reminderId});

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _messageController;
  late TextEditingController _relatedIdController;
  late ReminderType _type;
  late DateTime _time;
  late bool _isActive;
  late RepeatType _repeat;

  bool _isEditing = false;
  Reminder? _currentReminder;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _relatedIdController = TextEditingController();
    _type = ReminderType.medication;
    _time = DateTime.now();
    _isActive = true;
    _repeat = RepeatType.none;

    if (widget.reminderId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentReminder = ref
            .read(reminderListProvider)
            .value
            ?.firstWhere((rem) => rem.reminderId == widget.reminderId);
        if (_currentReminder != null) {
          _messageController.text = _currentReminder!.message;
          _relatedIdController.text = _currentReminder!.relatedId;
          _type = _currentReminder!.type;
          _time = _currentReminder!.time;
          _isActive = _currentReminder!.isActive;
          _repeat = _currentReminder!.repeat;
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _relatedIdController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (pickedTime != null) {
      setState(() {
        final now = DateTime.now();
        _time = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _saveReminder() async {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(userProvider)?.userId;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in.")));
        return;
      }

      final reminder = Reminder(
        reminderId:
            _isEditing ? _currentReminder!.reminderId : const Uuid().v4(),
        userId: userId,
        type: _type,
        relatedId: _relatedIdController.text,
        time: _time,
        message: _messageController.text,
        isActive: _isActive,
        repeat: _repeat,
      );

      try {
        if (_isEditing) {
          await ref
              .read(reminderListProvider.notifier)
              .updateReminder(reminder);
        } else {
          await ref.read(reminderListProvider.notifier).addReminder(reminder);
        }
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save reminder: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Reminder" : "Add Reminder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: "Message"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a message";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _relatedIdController,
                decoration: const InputDecoration(labelText: "Related ID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a related ID";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<ReminderType>(
                value: _type,
                decoration: const InputDecoration(labelText: "Reminder Type"),
                items:
                    ReminderType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              ListTile(
                title: const Text("Time"),
                subtitle: Text(_time.toLocal().toString().split(".")[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ),
              SwitchListTile(
                title: const Text("Is Active"),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              DropdownButtonFormField<RepeatType>(
                value: _repeat,
                decoration: const InputDecoration(labelText: "Repeat Type"),
                items:
                    RepeatType.values
                        .map(
                          (repeat) => DropdownMenuItem(
                            value: repeat,
                            child: Text(repeat.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _repeat = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _saveReminder,
                child: Text(_isEditing ? "Update Reminder" : "Add Reminder"),
              ),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(reminderListProvider.notifier)
                        .deleteReminder(_currentReminder!.reminderId);
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete Reminder"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
