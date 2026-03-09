import 'dart:io';

import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';

class CreateUserParams {
  final String email;
  final String username;
  final String password;
  final String role;
  final File? imageFile;

  const CreateUserParams({
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    this.imageFile,
  });
}

class CreateUserUseCase {
  final IAdminUserRepository repository;
  CreateUserUseCase(this.repository);

  Future<UserEntity> call(CreateUserParams params) => repository.createUser(
        email:     params.email,
        username:  params.username,
        password:  params.password,
        role:      params.role,
        imageFile: params.imageFile,
      );
}