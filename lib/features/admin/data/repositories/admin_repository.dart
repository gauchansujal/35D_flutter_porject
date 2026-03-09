import 'dart:io';

import 'package:flutter_application_1/features/admin/data/datasources/admin_datasource.dart';
import 'package:flutter_application_1/features/admin/data/datasources/remote/admin_remote_datasource.dart';
import 'package:flutter_application_1/features/admin/data/models/asdmin_user_api_model.dart';
import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/getall_users_usecases.dart'; // ✅ PaginatedUsers
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminUserRepositoryProvider = Provider<IAdminUserRepository>((ref) {
  return AdminUserRepositoryImpl(
    remoteDatasource: ref.read(adminRemoteDatasourceProvider),
  );
});

class AdminUserRepositoryImpl implements IAdminUserRepository {
  final IAdminUserRemoteDatasource remoteDatasource;

  AdminUserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<PaginatedUsers> getAllUsers({
    // ✅ updated
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    final result = await remoteDatasource.getAllUsers(
      page: page,
      size: size,
      search: search,
    );
    return PaginatedUsers(
      users: result.users.map((m) => m.toEntity()).toList(),
      page: result.page,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
    );
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final apiModel = await remoteDatasource.getUserById(id);
    return apiModel?.toEntity();
  }

  @override
  Future<UserEntity> createUser({
    required String email,
    required String username,
    required String password,
    required String role,
    File? imageFile,
  }) async {
    final apiModel = await remoteDatasource.createUser(
      UserApiModel(
        email: email,
        username: username,
        password: password,
        role: role,
      ),
      imageFile: imageFile,
    );
    return apiModel.toEntity();
  }

  @override
  Future<UserEntity> updateUser({
    required String id,
    required String email,
    required String username,
    required String role,
    File? imageFile,
  }) async {
    final apiModel = await remoteDatasource.updateUser(
      id,
      UserApiModel(email: email, username: username, role: role),
      imageFile: imageFile,
    );
    return apiModel.toEntity();
  }

  @override
  Future<bool> deleteUser(String id) async {
    return remoteDatasource.deleteUser(id);
  }
}
