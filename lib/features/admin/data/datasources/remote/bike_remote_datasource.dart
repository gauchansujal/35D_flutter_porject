import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/services/storage/token_services.dart';
import 'package:flutter_application_1/features/admin/data/datasources/bike_datasource.dart';
import 'package:flutter_application_1/features/admin/data/models/bike_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminBikeRemoteDatasourceProvider = Provider<IAdminBikeRemoteDataSource>((
  ref,
) {
  return AdminBikeRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServicesProvider),
  );
});

class AdminBikeRemoteDataSource implements IAdminBikeRemoteDataSource {
  final ApiClient _apiClient;
  final TokenServices _tokenServices;

  AdminBikeRemoteDataSource({
    required ApiClient apiClient,
    required TokenServices tokenService,
  }) : _apiClient = apiClient,
       _tokenServices = tokenService;

  // ── GET ALL  →  GET /bike ─────────────────────────
  @override
  Future<List<BikeApiModel>> getAllBikes() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bike);

      // ✅ API returns { "bikes": [...] } with no 'success' field
      final List data = response.data['bikes'] as List;
      return data
          .map((e) => BikeApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to fetch bikes',
        statusCode: e.response?.statusCode,
        message: e.response?.data?['message'] ?? 'Failed to fetch bikes',
      );
    }
  }

  // ── GET BY ID  →  GET /bike/:id ───────────────────
  @override
  Future<BikeApiModel?> getBikeById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bikeById(id));

      // ✅ POST returns bike object directly (no wrapper key)
      if (response.statusCode == 200) {
        return BikeApiModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to fetch bike',
        statusCode: e.response?.statusCode,
        message: e.response?.data?['message'] ?? 'Failed to fetch bike',
      );
    }
  }

  // ── CREATE  →  POST /bike  (admin only) ──────────
  @override
  Future<BikeApiModel> createBike(BikeApiModel bike, {File? imageFile}) async {
    try {
      final formData = FormData.fromMap({
        ...bike.toJson(),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _apiClient.post(ApiEndpoints.bike, data: formData);

      // ✅ POST returns bike object directly (no wrapper key)
      if (response.statusCode == 201 || response.statusCode == 200) {
        return BikeApiModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiFailure(
        'Create failed',
        message: response.data['message'] ?? 'Failed to create bike',
      );
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to create bike',
        statusCode: e.response?.statusCode,
        message: e.response?.data?['message'] ?? 'Failed to create bike',
      );
    }
  }

  // ── UPDATE  →  PUT /bike/:id  (admin only) ───────
  @override
  Future<BikeApiModel> updateBike(
    String id,
    BikeApiModel bike, {
    File? imageFile,
  }) async {
    try {
      final token = await _tokenServices.getToken();
      final formData = FormData.fromMap({
        ...bike.toJson(),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _apiClient.put(
        ApiEndpoints.bikeById(id),
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // ✅ PUT returns bike object directly (no wrapper key)
      if (response.statusCode == 200) {
        return BikeApiModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiFailure(
        'Update failed',
        message: response.data['message'] ?? 'Failed to update bike',
      );
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to update bike',
        statusCode: e.response?.statusCode,
        message: e.response?.data?['message'] ?? 'Failed to update bike',
      );
    }
  }

  // ── DELETE  →  DELETE /bike/:id  (admin only) ────
  @override
  Future<bool> deleteBike(String id) async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.bikeById(id));
      // ✅ Accept any 2xx as success
      return response.statusCode != null && response.statusCode! < 300;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to delete bike',
        statusCode: e.response?.statusCode,
        message: e.response?.data?['message'] ?? 'Failed to delete bike',
      );
    }
  }
}
