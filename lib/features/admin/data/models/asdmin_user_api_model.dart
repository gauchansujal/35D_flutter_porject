import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'dart:io';

class UserApiModel {
  final String? id;
  final String email;
  final String username;
  final String? password; // only sent on create, never returned
  final String role;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserApiModel({
    this.id,
    required this.email,
    required this.username,
    this.password,
    this.role = 'user',
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // ── fromJson  (server response → model) ──────────────────
  // Matches MongoDB field names: _id, email, username, role, imageUrl,
  // createdAt, updatedAt
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id:        json['_id']      as String? ?? json['id'] as String?,
      email:     json['email']    as String? ?? '',
      username:  json['username'] as String? ?? '',
      role:      json['role']     as String? ?? 'user',
      imageUrl:  json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  // ── toJson  (model → request body) ───────────────────────
  // password is excluded from updates — only included when creating
  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        'email':    email,
        'username': username,
        if (password != null) 'password': password,
        'role':     role,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

  // ── toFormData  (multipart: create / update with optional image) ──
  Future<FormData> toFormData({File? imageFile}) async {
    return FormData.fromMap({
      'email':    email,
      'username': username,
      if (password != null) 'password': password,
      'role':     role,
      if (imageFile != null)
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });
  }

  // ── toEntity  (model → domain) ───────────────────────────
  UserEntity toEntity() => UserEntity(
        id:        id ?? '',
        email:     email,
        username:  username,
        role:      role,
        imageUrl:  imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // ── fromEntity  (domain → model) ─────────────────────────
  factory UserApiModel.fromEntity(UserEntity entity) => UserApiModel(
        id:        entity.id,
        email:     entity.email,
        username:  entity.username,
        role:      entity.role,
        imageUrl:  entity.imageUrl,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}