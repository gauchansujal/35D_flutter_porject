import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/bike_repository.dart';

class GetAllBikesUsecase {
  final IAdminBikeRepository repository;
  GetAllBikesUsecase(this.repository);

  Future<List<BikeEntity>> call() => repository.getAllBikes();
}