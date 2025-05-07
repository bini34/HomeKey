import 'package:MediTrack/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:MediTrack/core/routes/router.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MEDITRACK',
      theme: AppTheme.lightThemeMode,
      routerConfig: router,
    );
  }
}
