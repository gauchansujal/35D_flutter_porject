import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/bike_card/data/datasources/bike_datasource.dart';
import 'package:flutter_application_1/features/bike_card/data/models/Bike_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bikeRemoteDatasourceProvider = Provider<IBikeRemoteDataSource>((ref) {
  return BikeRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BikeRemoteDatasource implements IBikeRemoteDataSource {
  final ApiClient _apiClient;

  BikeRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> addBike(BikeModel bike) {
    // TODO: implement addBike
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBike(String id) {
    // TODO: implement deleteBike
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getAllBikes() async {
    final response = await _apiClient.get('bike');
    // ✅ FIX: response.data is a Map like { "bikes": [...], "pagination": {...} }
    //         so we must access response.data['bikes'] before casting to List
    return (response.data['bikes'] as List)
        .map((e) => BikeModel.formJson(e))
        .toList();
  }

  @override
  Future<BikeModel> getBikeById(String id) {
    // TODO: implement getBikeById
    throw UnimplementedError();
  }

  @override
  Future<void> updateBike(String id, BikeModel bike) {
    // TODO: implement updateBike
    throw UnimplementedError();
  }
}
