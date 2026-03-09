import 'dart:io';

import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/bike_repository.dart';

class UpdateBikeUsecase {
  final IAdminBikeRepository repository;
  UpdateBikeUsecase(this.repository);

  Future<BikeEntity> call({
    required String id,
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable = true,
    File? imageFile,
  }) =>
      repository.updateBike(
        id:          id,
        name:        name,
        brand:       brand,
        price:       price,
        engineCC:    engineCC,
        milage:      milage,
        isAvailable: isAvailable,
        imageFile:   imageFile,
      );
}