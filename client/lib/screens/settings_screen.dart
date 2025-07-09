// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/model/user_model.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProfileSection(user),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // _buildSettingItem(
                  //   context,
                  //   'Change Password',
                  //   Icons.lock_outline,
                  // ),
                  // _buildSettingItem(context, 'Languages', Icons.language),
                  // _buildSettingItem(context, 'Payment Method', Icons.payment),
                  _buildSettingItem(
                    context,
                    'Privacy And Policy',
                    Icons.privacy_tip_outlined,
                  ),
                  _buildSettingItem(
                    context,
                    'Terms And Conditions',
                    Icons.description_outlined,
                  ),
                  _buildSettingItem(context, 'About Us', Icons.info_outline),
                  _buildSettingItem(context, 'Help', Icons.help_outline),
                  _buildDarkModeToggle(),
                  _buildDeleteAccount(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => _logout(context, ref),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildProfileSection(UserModel? user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child:
                user?.name != null
                    ? Text(
                      user!.name.split(' ').map((e) => e[0]).take(2).join(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : Icon(Icons.person, size: 30),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user?.name ?? 'Guest User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (user != null) ...[
                    SizedBox(width: 4),
                    Icon(Icons.verified, color: Colors.blue, size: 16),
                  ],
                ],
              ),
              Text(
                user?.email ?? 'guest@example.com',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(fontSize: 16))),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.nightlight_round, color: Colors.grey[600]),
          SizedBox(width: 16),
          Expanded(child: Text('Darkmode', style: TextStyle(fontSize: 16))),
          Switch(
            value: false,
            onChanged: (value) {},
            activeColor: Color(0xFFEF7D57),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Delete Account',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
