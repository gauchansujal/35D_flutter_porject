import 'dart:io';

import 'package:flutter_application_1/features/profile/data/models/profile_hive_model.dart';

abstract interface class IProfileLocalDataSource {
  //   /// Get the cached profile for a specific user/student
  //   Future<ProfileHiveModel?> getProfile(String studentId);

  //   /// Optional: Get all cached profiles (rarely needed if 1:1 relationship)
  //   /// Consider removing if you don't need multi-profile support
  //   Future<List<ProfileHiveModel>> getAllProfiles();

  //   /// Cache / create a new profile (returns success or throws)
  //   Future<void> UplodeProfile(ProfileHiveModel profile);

  //   //
  // }
  // // }
}

abstract interface class IProfileRemoteDataSource {
  /// Uploads profile image and returns the public URL from server
  Future<String> uploadProfileImage(File image);

  /// Uploads video (if profile has video field, e.g. intro video)
  Future<String> uploadProfileVideo(File video);

  // If profile has more remote operations, add them here, e.g.:
  // Future<ProfileModel> fetchProfile(String studentId);
  // Future<void> updateProfileRemote(ProfileModel profile);
}
