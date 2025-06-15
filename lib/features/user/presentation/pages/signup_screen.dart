import "package:MediTrack/features/user/domain/entity/user.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:MediTrack/features/user/presentation/providers/user_provider.dart";

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<User?>(userProvider, (previous, next) {
      if (next != null) {
        // User is logged in, navigate to home
        GoRouter.of(context).go("/");
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(userProvider.notifier)
                      .signUp(
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                      );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Sign Up Failed: $e")));
                }
              },
              child: const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go("/login");
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
