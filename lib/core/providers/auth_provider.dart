import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulated authentication provider
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  // Simulate a delay for checking login status
  await Future.delayed(const Duration(seconds: 2));
  // Replace this with actual logic to check login status
  return false; // Change to true if logged in
});