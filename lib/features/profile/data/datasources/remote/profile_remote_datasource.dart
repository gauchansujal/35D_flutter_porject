// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter_application_1/core/api/api_client.dart';
// import 'package:flutter_application_1/core/api/api_endpoints.dart';
// import 'package:flutter_application_1/core/services/storage/token_services.dart';
// import 'package:flutter_application_1/features/profile/data/datasources/local/profile_local_datasource.dart';
// import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
// import 'package:flutter_application_1/features/profile/data/datasources/remote/profile_remote_datasource.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final profileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((
//   ref,
// ) {
//   return ProfileRemoteDataSource(
//     apiClient: ref.read(apiClientProvider),
//     tokenServices: ref.read(tokenServicesProvider),
//   );
// });

// class ProfileRemoteDataSource implements IProfileRemoteDataSource {
//   final ApiClient _apiClient;
//   final TokenServices _tokenServices;

//   ProfileRemoteDataSource({
//     required ApiClient apiClient,
//     required TokenServices tokenServices,
//   }) : _apiClient = apiClient,
//        _tokenServices = tokenServices;

//   @override
//   Future<String> uploadProfileImage(File image) async {
//     final fileName = image.path.split('/').last;

//     final formData = FormData.fromMap({
//       'profilePicture': await MultipartFile.fromFile(
//         image.path,
//         filename: fileName,
//       ),
//     });

//     final token = await _tokenServices.getToken();

//     final response = await _apiClient.uploadFile(
//       ApiEndpoints.profileUploadImage, // ← make sure this constant exists
//       formData: formData,
//       options: Options(headers: {'Authorization': 'Bearer $token'}),
//     );

//     // Adjust parsing based on your actual API response
//     return response.data['url']?.toString() ??
//         response.data['data']?['url']?.toString() ??
//         'upload-success';
//   }

//   @override
//   Future<String> uploadProfileVideo(File video) async {
//     final fileName = video.path.split('/').last;

//     final formData = FormData.fromMap({
//       'video': await MultipartFile.fromFile(video.path, filename: fileName),
//     });

//     final token = await _tokenServices.getToken();

//     final response = await _apiClient.uploadFile(
//       ApiEndpoints.profileUploadVideo, // ← make sure this constant exists
//       formData: formData,
//       options: Options(headers: {'Authorization': 'Bearer $token'}),
//     );

//     return response.data['url']?.toString() ??
//         response.data['data']?['url']?.toString() ??
//         'upload-success';
//   }
// }
