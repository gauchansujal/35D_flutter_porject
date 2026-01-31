// import 'dart:io'; // if needed later

// import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';
// import 'package:flutter_application_1/features/profile/data/models/profile_api_model.dart'; // ← add if using fromApiModel
// import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';
// import 'package:hive/hive.dart';
// import 'package:uuid/uuid.dart'; // optional - only if auto-generating ids

// part 'profile_hive_model.g.dart';

// @HiveType(typeId: HiveTableConstant.profileTypeId)
// class ProfileHiveModel extends HiveObject {
//   @HiveField(0)
//   final String studentId;



//   ProfileHiveModel({
//     required this.studentId,
//     this.profilePicture,
   
//   });

//   ProfileEntity toEntity() {
//     return ProfileEntity(
//       studentId: studentId,
//       profilePicture: profilePicture,
   
//     );
//   }

//   factory ProfileHiveModel.fromEntity(ProfileEntity entity) {
//     return ProfileHiveModel(
//       studentId: entity.studentId,
//       profilePicture: entity.profilePicture,
     
//     );
//   }

//   static List<ProfileEntity> toEntityList(List<ProfileHiveModel> models) {
//     return models.map((model) => model.toEntity()).toList();
//   }

//   // ──────────────────────────────────────────────
//   // Optional: mapping from API model (uncomment when ready)
//   // ──────────────────────────────────────────────
//   /*
//   factory ProfileHiveModel.fromApiModel(ProfileApiModel apiModel) {
//     return ProfileHiveModel(
//       studentId: apiModel.studentId ?? apiModel.id ?? const Uuid().v4(),
//       profilePicture: apiModel.profilePicture,
//       fullName: apiModel.fullName,
//       bio: apiModel.bio,
//       location: apiModel.location,
//       createdAt: apiModel.createdAt,
//       updatedAt: apiModel.updatedAt,
//     );
//   }

//   static List<ProfileHiveModel> fromApiModelList(List<ProfileApiModel> apiModels) {
//     return apiModels.map(ProfileHiveModel.fromApiModel).toList();
//   }
//   */
// }
