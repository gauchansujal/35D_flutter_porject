import 'package:flutter_application_1/features/notifaction/domain/usecases/notification_usecase.dart';
import 'package:flutter_application_1/features/notifaction/presentation/provider/state/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
  () => NotificationViewModel(),
);

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetNotificationsUsecase _getNotifications;
  late final MarkAsReadUsecase _markAsRead;
  late final MarkAllAsReadUsecase _markAllAsRead;
  late final GetUnreadCountUsecase _getUnreadCount;

  @override
  NotificationState build() {
    _getNotifications = ref.read(getNotificationsUsecaseProvider);
    _markAsRead = ref.read(markAsReadUsecaseProvider);
    _markAllAsRead = ref.read(markAllAsReadUsecaseProvider);
    _getUnreadCount = ref.read(getUnreadCountUsecaseProvider);

    // Auto-load on build
    Future.microtask(() => loadNotifications());

    return NotificationState.initial();
  }

  // Load all notifications
  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationStatus.loading);

    try {
      final notifications = await _getNotifications();
      final unread = notifications.where((n) => n.isRead == false).length;

      state = state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: unread,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Mark single notification as read
  Future<void> markAsRead(String id) async {
    try {
      await _markAsRead(id);

      // Optimistic update
      final updated = state.notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();

      final unread = updated.where((n) => n.isRead == false).length;

      state = state.copyWith(
        notifications: updated,
        unreadCount: unread,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _markAllAsRead();

      final updated = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updated,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}