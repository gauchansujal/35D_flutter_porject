import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';

class GetUserByIdUseCase {
  final IAdminUserRepository repository;
  GetUserByIdUseCase(this.repository);

  Future<UserEntity?> call(String id) => repository.getUserById(id);
}