class NotificationEntity {
  final String? id;
  final String? userId;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? bookingId;
  final DateTime? createdAt;

  const NotificationEntity({
    this.id,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.bookingId,
    this.createdAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? bookingId,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      bookingId: bookingId ?? this.bookingId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}