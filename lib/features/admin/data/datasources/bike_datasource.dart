import 'dart:io';

import 'package:flutter_application_1/features/admin/data/models/bike_api_model.dart';

abstract class IAdminBikeRemoteDataSource {
  Future<List<BikeApiModel>> getAllBikes();
  Future<BikeApiModel?> getBikeById(String id);
  Future<BikeApiModel> createBike(BikeApiModel bike, {File? imageFile});
  Future<BikeApiModel> updateBike(String id, BikeApiModel bike, {File? imageFile});
  Future<bool> deleteBike(String id);
}