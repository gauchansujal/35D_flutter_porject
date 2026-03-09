import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';



class NotificationModel {
  final String? id;
  final String? user;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? bookingId;
  final String? createdAt;

  const NotificationModel({
    this.id,
    this.user,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.bookingId,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString(),
      user: json['user']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      type: json['type']?.toString(),
      isRead: json['is_read'] as bool?,
      bookingId: json['booking'] is Map
          ? json['booking']['_id']?.toString()
          : json['booking']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'title': title,
        'message': message,
        'type': type,
        'is_read': isRead,
        'booking': bookingId,
        'createdAt': createdAt,
      };

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: user,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? false,
      bookingId: bookingId,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      user: entity.userId,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      isRead: entity.isRead,
      bookingId: entity.bookingId,
      createdAt: entity.createdAt?.toIso8601String(),
    );
  }
}