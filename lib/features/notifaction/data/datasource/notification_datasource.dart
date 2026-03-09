import 'package:flutter_application_1/features/notifaction/data/model/notification_model.dart';



abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}