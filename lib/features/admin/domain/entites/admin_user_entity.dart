import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String role;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isUser  => role == 'user';

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? role,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id:        id        ?? this.id,
      email:     email     ?? this.email,
      username:  username  ?? this.username,
      role:      role      ?? this.role,
      imageUrl:  imageUrl  ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        role,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}