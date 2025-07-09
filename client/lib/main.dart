// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import 'package:homekey_mobile/features/property/presentations/all_properties_screen.dart';
import 'package:homekey_mobile/screens/profile_screen.dart';
import 'package:homekey_mobile/screens/settings_screen.dart';
import 'package:homekey_mobile/screens/splash_screen.dart';
import 'features/auth/presentations/welcome_screen.dart';
import 'features/property/presentations/home_screen.dart';
import 'features/auth/presentations/login_screen.dart';
// import 'package:homekey_mobile/screens/rent_now_screen.dart';
// import 'screens/identity_verification_camera_screen.dart';
// import 'screens/identity_verification_method_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return MaterialApp(
      title: 'Real Estate App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: Color(0xFFEF7D57),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        fontFamily: 'SF Pro Display',
      ),
      // initialRoute: '/welcome', // Keep welcome as initial for now
      home: authState.when(
        loading: () => SplashScreen(),
        error: (error, stack) => LoginScreen(), // Or error screen
        data: (user) => user != null ? HomeScreen() : LoginScreen(),
      ),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(), // Add the login route
        // '/identity_verification_camera':
        //     (context) => IdentityVerificationCameraScreen(),
        // '/identity_verification_method':
        //     (context) => IdentityVerificationMethodScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        // '/rent_now': (context) => RentNowScreen(),
        '/settings': (context) => SettingsScreen(),
        '/all_properties':
            (context) => AllPropertiesScreen(
              categoryTitle:
                  ModalRoute.of(context)!.settings.arguments as String? ??
                  'All Properties',
            ),
      },
    );
  }
}
