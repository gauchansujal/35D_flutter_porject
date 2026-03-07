import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_application_1/features/notifaction/presentation/pages/notification_page.dart';
import 'package:flutter_application_1/features/notifaction/presentation/viewmodel/notification_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch unread count from notification state
    final unreadCount = ref.watch(
      notificationViewModelProvider.select((s) => s.unreadCount),
    );

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

        // ✅ Notifications with red badge
        ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications, color: Colors.white),
              if (unreadCount > 0)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationPage()),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text("Logout", style: TextStyle(color: Colors.white)),
          onTap: () {
            ref.read(authViewModelProvider.notifier).logout();
          },
        ),
      ],
    );
  }
}
