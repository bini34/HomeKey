import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/user/presentation/pages/login_screen.dart';
import 'package:MediTrack/features/user/presentation/pages/signup_screen.dart';
import 'package:MediTrack/features/user/presentation/pages/profile_screen.dart';
import 'package:MediTrack/features/medication/presentation/pages/medication_list_screen.dart';
import 'package:MediTrack/features/medication/presentation/pages/medication_form_screen.dart';
import 'package:MediTrack/features/appointment/presentation/pages/appointment_list_screen.dart';
import 'package:MediTrack/features/appointment/presentation/pages/appointment_form_screen.dart';
import 'package:MediTrack/features/reminder/presentation/pages/reminder_settings_screen.dart';
import 'package:MediTrack/features/reminder/presentation/pages/reminder_form_screen.dart';
import 'package:MediTrack/features/health_log/presentation/pages/history_screen.dart';
import 'package:MediTrack/features/health_log/presentation/pages/health_log_form_screen.dart';
import 'package:MediTrack/features/pharmacy/presentation/pages/pharmacy_map_screen.dart';
import 'package:MediTrack/features/notification/presentation/pages/notification_screen.dart';
import 'package:MediTrack/features/home/presentation/pages/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignUpScreen()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/medications',
        builder: (context, state) => const MedicationListScreen(),
      ),
      GoRoute(
        path: '/medications/add',
        builder: (context, state) => const MedicationFormScreen(),
      ),
      GoRoute(
        path: '/medications/:medicationId',
        builder:
            (context, state) => MedicationFormScreen(
              medicationId: state.pathParameters['medicationId'],
            ),
      ),
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentListScreen(),
      ),
      GoRoute(
        path: '/appointments/add',
        builder: (context, state) => const AppointmentFormScreen(),
      ),
      GoRoute(
        path: '/appointments/:appointmentId',
        builder:
            (context, state) => AppointmentFormScreen(
              appointmentId: state.pathParameters['appointmentId'],
            ),
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const ReminderSettingsScreen(),
      ),
      GoRoute(
        path: '/reminders/add',
        builder: (context, state) => const ReminderFormScreen(),
      ),
      GoRoute(
        path: '/reminders/:reminderId',
        builder:
            (context, state) => ReminderFormScreen(
              reminderId: state.pathParameters['reminderId'],
            ),
      ),
      GoRoute(
        path: '/health_logs',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/health_logs/add',
        builder: (context, state) => const HealthLogFormScreen(),
      ),
      GoRoute(
        path: '/health_logs/:logId',
        builder:
            (context, state) =>
                HealthLogFormScreen(logId: state.pathParameters['logId']),
      ),
      GoRoute(
        path: '/pharmacy_map',
        builder: (context, state) => const PharmacyMapScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
});
