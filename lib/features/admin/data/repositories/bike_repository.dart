import 'dart:io';

import 'package:flutter_application_1/features/admin/data/datasources/bike_datasource.dart';
import 'package:flutter_application_1/features/admin/data/datasources/remote/bike_remote_datasource.dart';
import 'package:flutter_application_1/features/admin/data/models/bike_api_model.dart';
import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/admin/domain/repositories/bike_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminBikeRepositoryProvider = Provider<IAdminBikeRepository>((ref) {
  return AdminBikeRepositoryImpl(
    remoteDatasource: ref.read(adminBikeRemoteDatasourceProvider),
  );
});

class AdminBikeRepositoryImpl implements IAdminBikeRepository {
  final IAdminBikeRemoteDataSource remoteDatasource;

  AdminBikeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<BikeEntity>> getAllBikes() async {
    final models = await remoteDatasource.getAllBikes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BikeEntity?> getBikeById(String id) async {
    final model = await remoteDatasource.getBikeById(id);
    return model?.toEntity();
  }

  @override
  Future<BikeEntity> createBike({
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable = true,
    File? imageFile,
  }) async {
    final model = await remoteDatasource.createBike(
      BikeApiModel(
        name:        name,
        brand:       brand,
        price:       price,
        engineCC:    engineCC,
        milage:      milage,
        isAvailable: isAvailable,
      ),
      imageFile: imageFile,
    );
    return model.toEntity();
  }

  @override
  Future<BikeEntity> updateBike({
    required String id,
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable = true,
    File? imageFile,
  }) async {
    final model = await remoteDatasource.updateBike(
      id,
      BikeApiModel(
        name:        name,
        brand:       brand,
        price:       price,
        engineCC:    engineCC,
        milage:      milage,
        isAvailable: isAvailable,
      ),
      imageFile: imageFile,
    );
    return model.toEntity();
  }

  @override
  Future<bool> deleteBike(String id) async {
    return remoteDatasource.deleteBike(id);
  }
}