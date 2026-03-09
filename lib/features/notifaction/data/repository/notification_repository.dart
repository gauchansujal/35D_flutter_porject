import 'package:flutter_application_1/features/notifaction/data/datasource/notification_datasource.dart';
import 'package:flutter_application_1/features/notifaction/data/datasource/remote/notification_remote_datasource.dart';
import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';
import 'package:flutter_application_1/features/notifaction/domain/repostiroy/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.read(notificationRemoteDatasourceProvider),
  );
});

// ─── Implementation ───────────────────────────────────────────────────────────

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationRemoteDataSource _datasource; // ✅ use interface type

  NotificationRepositoryImpl(this._datasource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await _datasource.getNotifications();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(String id) => _datasource.markAsRead(id);

  @override
  Future<void> markAllAsRead() => _datasource.markAllAsRead();

  @override
  Future<int> getUnreadCount() => _datasource.getUnreadCount();
}