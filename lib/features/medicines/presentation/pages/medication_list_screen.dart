import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/medication/domain/entity/medication.dart';
import 'package:MediTrack/features/medication/presentation/providers/medication_provider.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsyncValue = ref.watch(medicationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).go('/medications/add');
            },
          ),
        ],
      ),
      body: medicationsAsyncValue.when(
        data: (medications) {
          if (medications.isEmpty) {
            return const Center(child: Text('No medications added yet.'));
          }
          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final medication = medications[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(medication.name),
                  subtitle: Text(
                    '${medication.dosage} - ${medication.frequency}',
                  ),
                  trailing: Text('Stock: ${medication.stockCount}'),
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).go('/medications/${medication.medicationId}');
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
