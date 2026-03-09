import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/bike_repository.dart';

class GetBikeByIdUsecase {
  final IAdminBikeRepository repository;
  GetBikeByIdUsecase(this.repository);

  Future<BikeEntity?> call(String id) => repository.getBikeById(id);
}