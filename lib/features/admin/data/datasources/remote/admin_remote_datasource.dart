import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/services/storage/token_services.dart';
import 'package:flutter_application_1/features/admin/data/datasources/admin_datasource.dart';
import 'package:flutter_application_1/features/admin/data/models/asdmin_user_api_model.dart';
import 'package:flutter_application_1/features/admin/data/repositories/admin_repository.dart' hide IAdminUserRemoteDatasource, PaginatedApiUsers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminRemoteDatasourceProvider = Provider<IAdminUserRemoteDatasource>((ref) {
  return AdminRemoteDatasource(
    apiClient:    ref.read(apiClientProvider),
    tokenService: ref.read(tokenServicesProvider),
  );
});

class AdminRemoteDatasource implements IAdminUserRemoteDatasource {
  final ApiClient _apiClient;
  final TokenServices _tokenServices;

  AdminRemoteDatasource({
    required ApiClient apiClient,
    required TokenServices tokenService,
  })  : _apiClient = apiClient,
        _tokenServices = tokenService;

  // ── GET ALL  →  GET /admin/users?page=1&size=10&search=... ──
  @override
  Future<PaginatedApiUsers> getAllUsers({ // ✅ updated
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.adminUsers,
        queryParameters: {           // ✅ send to backend
          'page': page,
          'size': size,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.data['success'] == true) {
        final List data       = response.data['data'] as List;
        final pagination      = response.data['pagination'] as Map<String, dynamic>;

        return PaginatedApiUsers(
          users: data
              .map((e) => UserApiModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          page:       pagination['page']       as int,
          totalPages: pagination['totalPages'] as int,
          totalItems: pagination['totalItems'] as int,
        );
      }
      return PaginatedApiUsers(users: [], page: 1, totalPages: 1, totalItems: 0);
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to fetch users',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to fetch users',
      );
    }
  }

  // ── GET BY ID  →  GET /admin/users/:id ───────────
  @override
  Future<UserApiModel?> getUserById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.adminUserById(id));
      if (response.data['success'] == true) {
        return UserApiModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to fetch user',
      );
    }
  }

  // ── CREATE  →  POST /admin/users ─────────────────
  @override
  Future<UserApiModel> createUser(UserApiModel user, {File? imageFile}) async {
    try {
      final formData = FormData.fromMap({
        ...user.toJson(),
        'confirmPassword': user.password,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.adminUsers,
        data: formData,
      );

      if (response.data['success'] == true) {
        return UserApiModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw ApiFailure(
        'Create failed',
        message: response.data['message'] ?? 'Failed to create user',
      );
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to create user',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to create user',
      );
    }
  }

  // ── UPDATE  →  PUT /admin/users/:id ──────────────
  @override
  Future<UserApiModel> updateUser(
    String id,
    UserApiModel user, {
    File? imageFile,
  }) async {
    try {
      final token    = await _tokenServices.getToken();
      final formData = FormData.fromMap({
        ...user.toJson(),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _apiClient.put(
        ApiEndpoints.adminUserById(id),
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        return UserApiModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw ApiFailure(
        'Update failed',
        message: response.data['message'] ?? 'Failed to update user',
      );
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to update user',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to update user',
      );
    }
  }

  // ── DELETE  →  DELETE /admin/users/:id ───────────
  @override
  Future<bool> deleteUser(String id) async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.adminUserById(id));
      return response.data['success'] == true;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to delete user',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to delete user',
      );
    }
  }

  // ── UPLOAD IMAGE ──────────────────────────────────
  @override
  Future<String?> uploadProfileImage(File image) async {
    try {
      final fileName = image.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });

      final token    = await _tokenServices.getToken();
      final response = await _apiClient.uploadFile(
        ApiEndpoints.adminUploadImage,
        formData: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['data'] as String?;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data?['message'] ?? 'Failed to upload image',
        statusCode: e.response?.statusCode,
        message:    e.response?.data?['message'] ?? 'Failed to upload image',
      );
    }
  }
}