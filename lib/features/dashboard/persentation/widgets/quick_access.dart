import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bike_card/presentation/pages/bike_page.dart';
import 'package:flutter_application_1/features/notifaction/presentation/viewmodel/notification_viewmodel.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/pages/uplod_document.dart';
import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';
import 'package:flutter_application_1/features/notifaction/presentation/pages/notification_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'icon_box.dart';

class QuickAccess extends ConsumerWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Access", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BikeListPage()),
                  ),
              child: const IconBox(
                icon: Icons.two_wheeler,
                color: Colors.orange,
              ),
            ),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UploadDocumentPage()),
                  ),
              child: const IconBox(icon: Icons.upload_file, color: Colors.red),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ✅ Recent Activity header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Activity",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  ),
              child: const Text(
                "View All",
                style: TextStyle(color: Colors.blueAccent, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ✅ Real notifications — latest 3
        if (notificationState.notifications.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "No recent activity",
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          )
        else
          ...notificationState.notifications
              .take(3)
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ActivityTile(notification: n),
                ),
              )
              .toList(),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final NotificationEntity notification;
  const _ActivityTile({required this.notification});

  Color get _dotColor {
    switch (notification.type) {
      case 'booking_confirmed':
        return Colors.green;
      case 'booking_cancelled':
        return Colors.red;
      case 'booking_updated':
        return Colors.orange;
      case 'booking_reminder':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  String get _timeAgo {
    if (notification.createdAt == null) return '';
    final diff = DateTime.now().difference(notification.createdAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.isRead == false;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(12),
        border:
            isUnread
                ? Border.all(color: Colors.blueAccent.withOpacity(0.3))
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  notification.message ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  _timeAgo,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
