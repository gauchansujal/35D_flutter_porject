// import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
// import 'package:flutter_application_1/features/profile/data/models/profile_hive_model.dart';

// class ProfileLocalDatasource implements IProfileLocalDataSource{
//   @override
//   Future<void> UplodeProfile(ProfileHiveModel profile) {
//     try {
//       final box = await _profileBox;

//       // studentId is used as the key → overwrites if already exists
//       await box.put(profile.studentId, profile);

//       print('Profile cached/updated for studentId: ${profile.studentId}');
//     } catch (e) {
//       print('Error caching profile in Hive: $e');
//       // You can throw a custom exception here if needed
//       rethrow;
//     }
//   }

//   @override
//   Future<List<ProfileHiveModel>> getAllProfiles(studentId) {
//     try {
//       final box = await _profileBox;
//       return box.get(studentId);
//     } catch (e) {
//       print('Error fetching profile from Hive: $e');
//       return null;
//     }
//   }

//   @override
//   Future<ProfileHiveModel?> getProfile(String studentId) {
   
//   }
// }