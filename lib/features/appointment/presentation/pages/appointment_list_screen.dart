import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/appointment/domain/entity/appointment.dart';
import 'package:MediTrack/features/appointment/presentation/providers/appointment_provider.dart';

class AppointmentListScreen extends ConsumerWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsyncValue = ref.watch(appointmentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).go('/appointments/add');
            },
          ),
        ],
      ),
      body: appointmentsAsyncValue.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments added yet.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(appointment.doctorName),
                  subtitle: Text(
                    '${appointment.specialty} - ${appointment.dateTime.toLocal().toString().split('.')[0]}',
                  ),
                  trailing: Text(appointment.status.name),
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).go('/appointments/${appointment.appointmentId}');
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
