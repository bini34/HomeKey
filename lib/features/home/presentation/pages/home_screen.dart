import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/user/presentation/providers/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediTrack Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              GoRouter.of(context).go('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              GoRouter.of(context).go('/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user?.email ?? 'Guest'}',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    user?.userId ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.medication),
              title: const Text('Medications'),
              onTap: () {
                GoRouter.of(context).go('/medications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointments'),
              onTap: () {
                GoRouter.of(context).go('/appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Reminders'),
              onTap: () {
                GoRouter.of(context).go('/reminders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Health Log'),
              onTap: () {
                GoRouter.of(context).go('/health_logs');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Pharmacies'),
              onTap: () {
                GoRouter.of(context).go('/pharmacy_map');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Implement logout functionality
                GoRouter.of(context).go('/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to MediTrack!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/medications');
              },
              child: const Text('View Medications'),
            ),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/appointments');
              },
              child: const Text('View Appointments'),
            ),
          ],
        ),
      ),
    );
  }
}
