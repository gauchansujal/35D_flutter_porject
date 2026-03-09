import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';


enum NotificationStatus { initial, loading, loaded, error }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final String? errorMessage;
  final int unreadCount;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.unreadCount = 0,
  });

  factory NotificationState.initial() => const NotificationState();

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    String? errorMessage,
    int? unreadCount,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}