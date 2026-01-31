import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/api/api_endpoints.dart';
import 'package:flutter_application_1/core/services/storage/token_services.dart';
import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProfileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServicesProvider),
  );
});

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final TokenServices _tokenServices;

  ProfileRemoteDataSource({
    required ApiClient apiClient,
    required TokenServices tokenService,
  }) : _apiClient = apiClient,
       _tokenServices = tokenService;
  @override
  Future<String> uploadProfileImage(File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    //get token
    final token = _tokenServices.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.uploadProfileImage,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['sucess'] as String;
  }

  @override
  Future<String> uploadProfileVideo(File video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'itemVideo': MultipartFile.fromFile(video.path, filename: fileName),
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
}
