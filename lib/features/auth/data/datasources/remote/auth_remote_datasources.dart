import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';
import 'package:flutter_application_1/core/services/storage/token_services.dart';
import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// PROVIDER
final authRemoteDatasourcesProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDataSources(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServicesProvider),
  );
});

/// IMPLEMENTATION
class AuthRemoteDataSources implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenServices _tokenServices;

  AuthRemoteDataSources({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenServices tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenServices = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.studentById(authId)}',
    );

    if (response.data['success'] == true) {
      return AuthApiModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    }
    return null;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.studentLogin, // ← this one!
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.userid ?? '',
        email: user.email,
        fullName: user.fullname,
      );

      final token = response.data['token'] as String?;
      await _tokenServices.saveToken(token!);
      // ADD THIS TEMPORARILY
      final verify = await _tokenServices.getToken();
      print('✅ TOKEN SAVED: $verify');
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final formData = FormData.fromMap({
      ...user.toJson(), // ✅ has username, firstname, lastname, email, password
      if (user.profilepicture != null)
        'image': await MultipartFile.fromFile(
          user.profilepicture!,
          filename: user.profilepicture!.split('/').last,
        ),
    });
    final response = await _apiClient.post(
      ApiEndpoints.studentRegister,
      data: formData,
    );

    // Typo fix: 'sucess' → 'success'
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    // Option 1 - most common & recommended
    throw Exception('Registration failed');

    // Option 2 - if you really want to return old object (not recommended)
    // return user;
  }

  @override
  Future<String> uploadProfileVideo(video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'image': MultipartFile.fromFile(video.path, filename: fileName),
    });
    //get token
    final token = _tokenServices.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.uploadProfileImage,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['sucess'];
  }

  @override
  Future<String?> uploadProfileImage(File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final token = await _tokenServices.getToken(); // ✅ await
    final response = await _apiClient.uploadFile(
      // ✅ put not uploadFile
      ApiEndpoints.studentRegister,
      formData: formData, // ✅ data not formData
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // ✅ space fixed by await
        },
      ),
    );

    return response.data['data'] as String?;
  }

  @override
  Future<void> updateProfile(AuthEntity profile) async {
    final Map<String, dynamic> fields = {};

    // ✅ Only add fields that are NOT null — backend keeps old value for rest
    if (profile.fullName != null && profile.fullName!.trim().isNotEmpty) {
      fields['username'] = profile.fullName;
    }
    if (profile.email != null && profile.email!.trim().isNotEmpty) {
      fields['email'] = profile.email;
    }
    if (profile.password != null && profile.password!.trim().isNotEmpty) {
      fields['password'] = profile.password;
    }

    // ✅ Use localProfilePicturePath (local file path) not profilePicture (server URL)
    if (profile.localProfilePicturePath != null) {
      final fileName = profile.localProfilePicturePath!.split('/').last;
      fields['image'] = await MultipartFile.fromFile(
        profile.localProfilePicturePath!,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap(fields);
    final token = await _tokenServices.getToken();

    await _apiClient.put(
      // ✅ PUT not POST
      ApiEndpoints.StudentUpdateProfile,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
