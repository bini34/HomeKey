import 'package:MediTrack/features/auth/presentation/pages/EmailVerificationPage.dart';
import 'package:MediTrack/features/auth/presentation/pages/ForgetPasswordPage.dart';
import 'package:MediTrack/features/auth/presentation/pages/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/features/auth/presentation/pages/SignupEmailPage.dart';
import 'package:MediTrack/features/auth/presentation/pages/signin_page.dart';
import 'package:MediTrack/features/auth/presentation/pages/SignupPasswordPage.dart';
import 'package:MediTrack/features/auth/presentation/pages/SignupSuccessPage.dart';
import 'package:MediTrack/features/auth/presentation/pages/NewPasswordPage.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupEmailPage(),
  ),
  GoRoute(path: '/signin', builder: (context, state) => const SigninPage()),
  GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
  GoRoute(
    path: '/signup-password',
    builder: (context, state) => const SignupPasswordPage(),
  ),
  GoRoute(
    path: '/signup-success',
    builder: (context, state) => const SignupSuccessPage(),
  ),
  GoRoute(
    path: '/forget-password',
    builder: (context, state) => const ForgetPasswordPage(),
  ),
  GoRoute(
    path: '/email-verify',
    builder: (context, state) => const EmailVerificationPage(),
  ),
  GoRoute(
    path: '/new-password',
    builder: (context, state) => const NewPasswordPage(),
  ),
  // Add more auth related routes here
];
