import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData get _icon {
    switch (notification.type) {
      case 'booking_confirmed':
        return Icons.check_circle_outline;
      case 'booking_cancelled':
        return Icons.cancel_outlined;
      case 'booking_updated':
        return Icons.edit_calendar_outlined;
      case 'booking_reminder':
        return Icons.alarm;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color get _color {
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
        return Colors.grey;
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead ?? true;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isRead ? Colors.transparent : Colors.white.withOpacity(0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _color, size: 22),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!isRead)
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
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}