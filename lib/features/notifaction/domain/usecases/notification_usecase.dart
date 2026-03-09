import 'package:flutter_application_1/features/notifaction/data/repository/notification_repository.dart';
import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';
import 'package:flutter_application_1/features/notifaction/domain/repostiroy/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Get Notifications ───────────────────────────────────────────────────────

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((ref) {
  return GetNotificationsUsecase(ref.read(notificationRepositoryProvider));
});

class GetNotificationsUsecase {
  final INotificationRepository _repository;
  GetNotificationsUsecase(this._repository);

  Future<List<NotificationEntity>> call() => _repository.getNotifications();
}

// ─── Mark As Read ────────────────────────────────────────────────────────────

final markAsReadUsecaseProvider = Provider<MarkAsReadUsecase>((ref) {
  return MarkAsReadUsecase(ref.read(notificationRepositoryProvider));
});

class MarkAsReadUsecase {
  final INotificationRepository _repository;
  MarkAsReadUsecase(this._repository);

  Future<void> call(String id) => _repository.markAsRead(id);
}

// ─── Mark All As Read ────────────────────────────────────────────────────────

final markAllAsReadUsecaseProvider = Provider<MarkAllAsReadUsecase>((ref) {
  return MarkAllAsReadUsecase(ref.read(notificationRepositoryProvider));
});

class MarkAllAsReadUsecase {
  final INotificationRepository _repository;
  MarkAllAsReadUsecase(this._repository);

  Future<void> call() => _repository.markAllAsRead();
}

// ─── Get Unread Count ────────────────────────────────────────────────────────

final getUnreadCountUsecaseProvider = Provider<GetUnreadCountUsecase>((ref) {
  return GetUnreadCountUsecase(ref.read(notificationRepositoryProvider));
});

class GetUnreadCountUsecase {
  final INotificationRepository _repository;
  GetUnreadCountUsecase(this._repository);

  Future<int> call() => _repository.getUnreadCount();
}