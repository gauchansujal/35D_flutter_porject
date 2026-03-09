import 'dart:io';

import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';

abstract class IAdminBikeRepository {
  Future<List<BikeEntity>> getAllBikes();
  
  Future<BikeEntity?> getBikeById(String id);

  Future<BikeEntity> createBike({
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable,
    File? imageFile,
  });

  Future<BikeEntity> updateBike({
    required String id,
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable,
    File? imageFile,
  });

  Future<bool> deleteBike(String id);
}