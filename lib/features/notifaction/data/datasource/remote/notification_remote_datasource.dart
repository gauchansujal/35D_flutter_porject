import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/notifaction/data/datasource/notification_datasource.dart';
import 'package:flutter_application_1/features/notifaction/data/model/notification_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSource(
        apiClient: ref.read(apiClientProvider),
      );
    });

// ─── Implementation ───────────────────────────────────────────────────────────

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get('/notification');

    if (response.data['success'] == true) {
      final List data = response.data['data'] as List;
      return data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<void> markAsRead(String id) async {
    await _apiClient.patch('/notification/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch('/notification/read-all');
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get('/notification/unread-count');

    if (response.data['success'] == true) {
      return response.data['unread_count'] as int? ?? 0;
    }
    return 0;
  }
}
