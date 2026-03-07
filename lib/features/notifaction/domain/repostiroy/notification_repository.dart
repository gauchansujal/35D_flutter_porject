import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';



abstract class INotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}