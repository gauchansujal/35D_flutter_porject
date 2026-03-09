import 'dart:io';

import 'package:flutter_application_1/features/admin/data/models/asdmin_user_api_model.dart';

// ✅ Pagination wrapper — defined here so both datasource and repository can use it
class PaginatedApiUsers {
  final List<UserApiModel> users;
  final int page;
  final int totalPages;
  final int totalItems;

  PaginatedApiUsers({
    required this.users,
    required this.page,
    required this.totalPages,
    required this.totalItems,
  });
}

abstract interface class IAdminUserRemoteDatasource {
  /// GET /admin/users?page=1&size=10&search=...
  Future<PaginatedApiUsers> getAllUsers({ // ✅ updated
    int page,
    int size,
    String? search,
  });

  /// GET /admin/users/:id
  Future<UserApiModel?> getUserById(String id);

  /// POST /admin/users  (multipart — name, email, password, role, image?)
  Future<UserApiModel> createUser(UserApiModel user, {File? imageFile});

  /// PUT /admin/users/:id  (multipart — name, email, role, image?)
  Future<UserApiModel> updateUser(
    String id,
    UserApiModel user, {
    File? imageFile,
  });

  /// DELETE /admin/users/:id
  Future<bool> deleteUser(String id);

  /// Uploads a profile image independently and returns the public URL
  Future<String?> uploadProfileImage(File image);
}