import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:MediTrack/features/medication/domain/entity/medication.dart';
import 'package:MediTrack/features/medication/presentation/providers/medication_provider.dart';
import 'package:MediTrack/features/user/presentation/providers/user_provider.dart';

class MedicationFormScreen extends ConsumerStatefulWidget {
  final String? medicationId;
  const MedicationFormScreen({super.key, this.medicationId});

  @override
  ConsumerState<MedicationFormScreen> createState() =>
      _MedicationFormScreenState();
}

class _MedicationFormScreenState extends ConsumerState<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _frequencyController;
  late TextEditingController _stockCountController;
  late TextEditingController _notesController;
  late List<DateTime> _timeOfDay;
  late DateTime _startDate;
  DateTime? _endDate;

  bool _isEditing = false;
  Medication? _currentMedication;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dosageController = TextEditingController();
    _frequencyController = TextEditingController();
    _stockCountController = TextEditingController();
    _notesController = TextEditingController();
    _timeOfDay = [];
    _startDate = DateTime.now();

    if (widget.medicationId != null) {
      _isEditing = true;
      // Fetch medication details if in editing mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentMedication = ref
            .read(medicationListProvider)
            .value
            ?.firstWhere((med) => med.medicationId == widget.medicationId);
        if (_currentMedication != null) {
          _nameController.text = _currentMedication!.name;
          _dosageController.text = _currentMedication!.dosage;
          _frequencyController.text = _currentMedication!.frequency;
          _stockCountController.text =
              _currentMedication!.stockCount.toString();
          _notesController.text = _currentMedication!.notes ?? '';
          _timeOfDay = _currentMedication!.timeOfDay;
          _startDate = _currentMedication!.startDate;
          _endDate = _currentMedication!.endDate;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _stockCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        _timeOfDay.add(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(userProvider)?.userId;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in.')));
        return;
      }

      final medication = Medication(
        medicationId:
            _isEditing ? _currentMedication!.medicationId : const Uuid().v4(),
        userId: userId,
        name: _nameController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
        timeOfDay: _timeOfDay,
        startDate: _startDate,
        endDate: _endDate,
        stockCount: int.parse(_stockCountController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      try {
        if (_isEditing) {
          await ref
              .read(medicationListProvider.notifier)
              .updateMedication(medication);
        } else {
          await ref
              .read(medicationListProvider.notifier)
              .addMedication(medication);
        }
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save medication: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medication' : 'Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medication name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dosage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(labelText: 'Frequency'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter frequency';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockCountController,
                decoration: const InputDecoration(labelText: 'Stock Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                ),
                maxLines: 3,
              ),
              ListTile(
                title: const Text('Times of Day'),
                subtitle: Text(
                  _timeOfDay.isEmpty
                      ? 'No times selected'
                      : _timeOfDay
                          .map(
                            (e) =>
                                '${e.hour}:${e.minute.toString().padLeft(2, '0')}',
                          )
                          .join(', '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_alarm),
                  onPressed: () => _selectTime(context),
                ),
              ),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(_startDate.toLocal().toString().split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              ListTile(
                title: const Text('End Date (Optional)'),
                subtitle: Text(
                  _endDate == null
                      ? 'No end date'
                      : _endDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              ElevatedButton(
                onPressed: _saveMedication,
                child: Text(
                  _isEditing ? 'Update Medication' : 'Add Medication',
                ),
              ),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(medicationListProvider.notifier)
                        .deleteMedication(_currentMedication!.medicationId);
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete Medication'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
