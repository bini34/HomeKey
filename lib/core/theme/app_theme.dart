
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xFF4A90E2),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: const MaterialColor(
        0xFF4A90E2,
        <int, Color>{
          50: Color(0xFFE9F2FC),
          100: Color(0xFFC7DDF8),
          200: Color(0xFFA0C7F4),
          300: Color(0xFF78B0EF),
          400: Color(0xFF5B9EEB),
          500: Color(0xFF4A90E2),
          600: Color(0xFF4383D9),
          700: Color(0xFF3B74CF),
          800: Color(0xFF3366C5),
          900: Color(0xFF254BAF),
        },
      ),
      accentColor: const Color(0xFF50E3C2),
    ).copyWith(
      secondary: const Color(0xFF50E3C2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4A90E2),
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF50E3C2),
      foregroundColor: Colors.white,
    ),
  );
}


