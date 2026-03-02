import 'dart:io';

import 'package:flutter_application_1/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthLocalDatasource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<AuthHiveModel?> getUserById(String authId);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> UpdateUser(AuthHiveModel user);
  Future<bool> deleteUser(String authId);

  //get email exits
  Future<bool> isEmailExists(String email);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<void> updateProfile(AuthEntity profile);
  

  /// Uploads profile image and returns the public URL from server
  Future<String?> uploadProfileImage(File image);

  /// Uploads video (if profile has video field, e.g. intro video)
  Future<String> uploadProfileVideo(File video);

  // If profile has more remote operations, add them here, e.g.:
  // Future<ProfileModel> fetchProfile(String studentId);
  // Future<void> updateProfileRemote(ProfileModel profile);
}
