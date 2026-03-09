import 'dart:io';

import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/getall_users_usecases.dart';

abstract interface class IAdminUserRepository {
  
  Future<PaginatedUsers> getAllUsers({ // ✅ updated
    int page,
    int size,
    String? search,
  });

  Future<UserEntity?> getUserById(String id);

  Future<UserEntity> createUser({
    required String email,
    required String username,
    required String password,
    required String role,
    File? imageFile,
  });

  Future<UserEntity> updateUser({
    required String id,
    required String email,
    required String username,
    required String role,
    File? imageFile,
  });

  Future<bool> deleteUser(String id);
}