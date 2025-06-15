import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "package:MediTrack/features/health_log/domain/entity/health_log.dart";
import "package:MediTrack/features/health_log/presentation/providers/health_log_provider.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

class HealthLogFormScreen extends ConsumerStatefulWidget {
  final String? logId;
  const HealthLogFormScreen({super.key, this.logId});

  @override
  ConsumerState<HealthLogFormScreen> createState() =>
      _HealthLogFormScreenState();
}

class _HealthLogFormScreenState extends ConsumerState<HealthLogFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;
  late TextEditingController _notesController;
  late HealthLogType _type;
  late DateTime _dateTime;

  bool _isEditing = false;
  HealthLog? _currentHealthLog;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
    _notesController = TextEditingController();
    _type = HealthLogType.bloodPressure; // Default type
    _dateTime = DateTime.now();

    if (widget.logId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentHealthLog = ref
            .read(healthLogListProvider)
            .value
            ?.firstWhere((log) => log.logId == widget.logId);
        if (_currentHealthLog != null) {
          _valueController.text = _currentHealthLog!.value;
          _notesController.text = _currentHealthLog!.notes ?? "";
          _type = _currentHealthLog!.type;
          _dateTime = _currentHealthLog!.dateTime;
        }
      });
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveHealthLog() async {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(userProvider)?.userId;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in.")));
        return;
      }

      final healthLog = HealthLog(
        logId: _isEditing ? _currentHealthLog!.logId : const Uuid().v4(),
        userId: userId,
        type: _type,
        value: _valueController.text,
        dateTime: _dateTime,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      try {
        if (_isEditing) {
          await ref
              .read(healthLogListProvider.notifier)
              .updateHealthLog(healthLog);
        } else {
          await ref
              .read(healthLogListProvider.notifier)
              .addHealthLog(healthLog);
        }
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save health log: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Health Log" : "Add Health Log"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<HealthLogType>(
                value: _type,
                decoration: const InputDecoration(labelText: "Log Type"),
                items:
                    HealthLogType.values
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
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: "Value"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text("Date and Time"),
                subtitle: Text(_dateTime.toLocal().toString().split(".")[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context),
                ),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Notes (Optional)",
                ),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: _saveHealthLog,
                child: Text(
                  _isEditing ? "Update Health Log" : "Add Health Log",
                ),
              ),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(healthLogListProvider.notifier)
                        .deleteHealthLog(_currentHealthLog!.logId);
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete Health Log"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
