import 'package:MediTrack/features/auth/presentation/pages/welcome_page.dart';
import 'package:MediTrack/features/splash_screen/presentation/pages/splash.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/core/config/routes/auth_routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),

    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    ...authRoutes,
  ],
);
