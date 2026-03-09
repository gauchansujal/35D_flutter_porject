import 'package:flutter_application_1/features/admin/domain/repositories/bike_repository.dart';

class DeleteBikeUsecase {
  final IAdminBikeRepository repository;
  DeleteBikeUsecase(this.repository);

  Future<bool> call(String id) => repository.deleteBike(id);
}