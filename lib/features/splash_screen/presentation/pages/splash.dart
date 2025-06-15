import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:MediTrack/core/providers/auth_provider.dart'; // Import the provider

class Splash extends ConsumerWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(isLoggedInProvider);

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: authState.when(
          data: (isLoggedIn) {
            // Schedule navigation after the widget tree is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (isLoggedIn) {
                context.go('/home'); // Use GoRouter's navigation method
              } else {
                context.go('/welcome'); // Use GoRouter's navigation method
              }
            });
            return _buildSplashContent();
          },
          loading: () => _buildSplashContent(),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Stack(
      children: [
        // Centered logo in the middle
        Center(
          child: Image.asset('assets/icon/splash.png', width: 150, height: 150),
        ),

        // Bottom text
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              'MediTrack',
              style: TextStyle(
                color: const Color.fromARGB(255, 175, 175, 175),
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}