import 'package:flutter_application_1/features/bike_card/data/models/Bike_Model.dart';

abstract interface class IBikeRemoteDataSource {
  Future<BikeModel> getBikeById(String id);
  Future<List<BikeModel>> getAllBikes();
  Future<void> addBike(BikeModel bike);
  Future<void> updateBike(String id, BikeModel bike);
  Future<void> deleteBike(String id);
}
