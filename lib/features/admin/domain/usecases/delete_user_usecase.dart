import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';
class DeleteUserUseCase {
  final IAdminUserRepository repository;
  DeleteUserUseCase(this.repository);

  Future<bool> call(String id) => repository.deleteUser(id);
}