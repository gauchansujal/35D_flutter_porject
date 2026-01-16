import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LISTEN for state changes to handle navigation automatically
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Logout Failed')),
        );
      }
    });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: Icon(Icons.lock, color: Colors.white),
          title: Text("Change Password", style: TextStyle(color: Colors.white)),
        ),
        const ListTile(
          leading: Icon(Icons.notifications, color: Colors.white),
          title: Text("Notifications", style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text("Logout", style: TextStyle(color: Colors.white)),
          onTap: () {
            // Trigger the logout process
            ref.read(authViewModelProvider.notifier).logout();
          },
        ),
      ],
    );
  }
}
