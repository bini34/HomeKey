import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:MediTrack/features/appointment/domain/entity/appointment.dart';
import 'package:MediTrack/features/appointment/presentation/providers/appointment_provider.dart';
import 'package:MediTrack/features/user/presentation/providers/user_provider.dart';

class AppointmentFormScreen extends ConsumerStatefulWidget {
  final String? appointmentId;
  const AppointmentFormScreen({super.key, this.appointmentId});

  @override
  ConsumerState<AppointmentFormScreen> createState() =>
      _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends ConsumerState<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _doctorNameController;
  late TextEditingController _specialtyController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _dateTime;
  late AppointmentStatus _status;

  bool _isEditing = false;
  Appointment? _currentAppointment;

  @override
  void initState() {
    super.initState();
    _doctorNameController = TextEditingController();
    _specialtyController = TextEditingController();
    _locationController = TextEditingController();
    _notesController = TextEditingController();
    _dateTime = DateTime.now();
    _status = AppointmentStatus.scheduled;

    if (widget.appointmentId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _currentAppointment = ref
            .read(appointmentListProvider)
            .value
            ?.firstWhere((app) => app.appointmentId == widget.appointmentId);
        if (_currentAppointment != null) {
          _doctorNameController.text = _currentAppointment!.doctorName;
          _specialtyController.text = _currentAppointment!.specialty;
          _locationController.text = _currentAppointment!.location;
          _notesController.text = _currentAppointment!.notes ?? '';
          _dateTime = _currentAppointment!.dateTime;
          _status = _currentAppointment!.status;
        }
      });
    }
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
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

  void _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(userProvider)?.userId;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in.')));
        return;
      }

      final appointment = Appointment(
        appointmentId:
            _isEditing ? _currentAppointment!.appointmentId : const Uuid().v4(),
        userId: userId,
        doctorName: _doctorNameController.text,
        specialty: _specialtyController.text,
        dateTime: _dateTime,
        location: _locationController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        status: _status,
      );

      try {
        if (_isEditing) {
          await ref
              .read(appointmentListProvider.notifier)
              .updateAppointment(appointment);
        } else {
          await ref
              .read(appointmentListProvider.notifier)
              .addAppointment(appointment);
        }
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save appointment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Appointment' : 'Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doctorNameController,
                decoration: const InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specialty';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Date and Time'),
                subtitle: Text(_dateTime.toLocal().toString().split('.')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context),
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
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
              DropdownButtonFormField<AppointmentStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items:
                    AppointmentStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _saveAppointment,
                child: Text(
                  _isEditing ? 'Update Appointment' : 'Add Appointment',
                ),
              ),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(appointmentListProvider.notifier)
                        .deleteAppointment(_currentAppointment!.appointmentId);
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete Appointment'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
