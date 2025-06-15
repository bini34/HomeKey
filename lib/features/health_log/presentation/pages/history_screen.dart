import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/health_log/domain/entity/health_log.dart';
import 'package:MediTrack/features/health_log/presentation/providers/health_log_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthLogsAsyncValue = ref.watch(healthLogListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Log History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).go('/health_logs/add');
            },
          ),
        ],
      ),
      body: healthLogsAsyncValue.when(
        data: (healthLogs) {
          if (healthLogs.isEmpty) {
            return const Center(child: Text('No health logs recorded yet.'));
          }
          return ListView.builder(
            itemCount: healthLogs.length,
            itemBuilder: (context, index) {
              final log = healthLogs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${log.type.name.toUpperCase()}: ${log.value}'),
                  subtitle: Text(
                    '${log.dateTime.toLocal().toString().split('.')[0]} - ${log.notes ?? 'No notes'}',
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/health_logs/${log.logId}');
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
