import 'dart:io';

import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';

class UpdateUserParams {
  final String id;
  final String email;
  final String username;
  final String role;
  final File? imageFile;

  const UpdateUserParams({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    this.imageFile,
  });
}

class UpdateUserUseCase {
  final IAdminUserRepository repository;
  UpdateUserUseCase(this.repository);

  Future<UserEntity> call(UpdateUserParams params) => repository.updateUser(
        id:        params.id,
        email:     params.email,
        username:  params.username,
        role:      params.role,
        imageFile: params.imageFile,
      );
}