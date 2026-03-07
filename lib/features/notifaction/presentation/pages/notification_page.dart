import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/notifaction/presentation/provider/state/notification_state.dart';
import 'package:flutter_application_1/features/notifaction/presentation/viewmodel/notification_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/notification_tile.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () => viewModel.markAllAsRead(),
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.blueAccent, fontSize: 13),
              ),
            ),
        ],
      ),
      body: _buildBody(state, viewModel),
    );
  }

  Widget _buildBody(NotificationState state, NotificationViewModel viewModel) {
    switch (state.status) {
      case NotificationStatus.initial:
      case NotificationStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        );

      case NotificationStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.loadNotifications(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case NotificationStatus.loaded:
        if (state.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined,
                    color: Colors.white24, size: 64),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.blueAccent,
          backgroundColor: const Color(0xFF0D1117),
          onRefresh: () => viewModel.loadNotifications(),
          child: ListView.separated(
            itemCount: state.notifications.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.white10,
              height: 1,
              indent: 70,
            ),
            itemBuilder: (context, index) {
              return NotificationTile(
                notification: state.notifications[index],
                onTap: () {
                  final id = state.notifications[index].id;
                  if (id != null && state.notifications[index].isRead == false) {
                    viewModel.markAsRead(id);
                  }
                },
              );
            },
          ),
        );
    }
  }
}