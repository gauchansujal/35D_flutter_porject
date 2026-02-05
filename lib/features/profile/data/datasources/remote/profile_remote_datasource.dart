// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_application_1/core/api/api_client.dart';
// import 'package:flutter_application_1/core/api/api_endpoints.dart';
// import 'package:flutter_application_1/core/services/storage/token_services.dart';
// import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final ProfileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((
//   ref,
// ) {
//   return ProfileRemoteDataSource(
//     apiClient: ref.read(apiClientProvider),
//     tokenService: ref.read(tokenServicesProvider),
//   );
// });

// class ProfileRemoteDataSource implements IProfileRemoteDataSource {
//   final ApiClient _apiClient;
//   final TokenServices _tokenServices;

//   ProfileRemoteDataSource({
//     required ApiClient apiClient,
//     required TokenServices tokenService,
//   }) : _apiClient = apiClient,
//        _tokenServices = tokenService;
//   @override
//   Future<String> uploadProfileImage(File image) async {
//     try {
//       final fileName = image.path.split(Platform.pathSeparator).last;

//       final formData = FormData.fromMap({
//         'profilePicture': await MultipartFile.fromFile(
//           image.path,
//           filename: fileName,
//         ),
//       });

//       final token = _tokenServices.getToken(); // await if it's async

//       final response = await _apiClient.uploadFile(
//         ApiEndpoints.uploadProfileImage,
//         formData: formData,
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );

//       // Debug print – keep this until fixed
//       print('Upload full response: ${response.data}');

//       // Safely extract URL – try multiple keys in priority order
//       final String? imageUrl =
//           response.data['url'] as String? ??
//           response.data['data'] as String?; // fallback to old field

//       if (imageUrl == null || imageUrl.trim().isEmpty) {
//         throw Exception(
//           'No valid URL returned from server\nFull response: ${response.data}',
//         );
//       }

//       // Optional: make full URL (use your actual server address)
//       // For emulator localhost → use 10.0.2.2
//       const baseUrl = 'http://10.0.2.2:3000'; // ← change port if different
//       // const baseUrl = 'http://192.168.1.xxx:3000'; // for real device

//       final fullUrl = '$baseUrl$imageUrl';
//       print('Full image URL: $fullUrl');

//       return fullUrl; // return full URL so NetworkImage works directly
//     } catch (e) {
//       print('Upload error: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<String> uploadProfileVideo(File video) async {
//     final fileName = video.path.split('/').last;
//     final formData = FormData.fromMap({
//       'itemVideo': MultipartFile.fromFile(video.path, filename: fileName),
//     });
//     //get token
//     final token = _tokenServices.getToken();
//     final response = await _apiClient.uploadFile(
//       ApiEndpoints.uploadProfileImage,
//       formData: formData,
//       options: Options(headers: {'Authorization': 'Bearer $token'}),
//     );
//     return response.data['sucess'];
//   }
// }
