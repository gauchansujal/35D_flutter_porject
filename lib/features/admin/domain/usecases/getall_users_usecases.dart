import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/admin_repository.dart';

// ✅ Pagination result model
class PaginatedUsers {
  final List<UserEntity> users;
  final int page;
  final int totalPages;
  final int totalItems;

  PaginatedUsers({
    required this.users,
    required this.page,
    required this.totalPages,
    required this.totalItems,
  });
}

class GetAllUsersUseCase {
  final IAdminUserRepository repository;
  GetAllUsersUseCase(this.repository);

  Future<PaginatedUsers> call({  // ✅ returns PaginatedUsers not List
    int page = 1,
    int size = 10,
    String? search,
  }) =>
      repository.getAllUsers(page: page, size: size, search: search);
}