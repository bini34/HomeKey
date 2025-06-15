import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/reminder/domain/entity/reminder.dart';
import 'package:MediTrack/features/reminder/presentation/providers/reminder_provider.dart';

class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsyncValue = ref.watch(reminderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to reminder form screen
            },
          ),
        ],
      ),
      body: remindersAsyncValue.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return const Center(child: Text('No reminders set yet.'));
          }
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(reminder.message),
                  subtitle: Text(
                    '${reminder.type.name.toUpperCase()} - ${reminder.time.toLocal().toString().split('.')[0]} - ${reminder.repeat.name.toUpperCase()}',
                  ),
                  trailing: Switch(
                    value: reminder.isActive,
                    onChanged: (bool value) {
                      ref
                          .read(reminderListProvider.notifier)
                          .updateReminder(reminder.copyWith(isActive: value));
                    },
                  ),
                  onTap: () {
                    // TODO: Navigate to reminder form screen for editing
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
