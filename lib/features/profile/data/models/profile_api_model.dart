// import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'profile_api_model.g.dart';

// /// Helper to extract ID from nested object or string (same as in ItemApiModel)
// String? _extractId(dynamic value) {
//   if (value == null) return null;
//   if (value is Map) return value['_id'] as String?;
//   return value as String?;
// }

// @JsonSerializable()
// class ProfileApiModel {
//   @JsonKey(name: '_id')
//   final String? id;

//   @JsonKey(fromJson: _extractId)
//   final String? studentId;           // Main identifier (usually same as user/student ID)

//   final String? profilePicture;      // URL string
//   final String? fullName;
//   final String? bio;
//   final String? phoneNumber;
//   final String? location;

//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   ProfileApiModel({
//     this.id,
//     this.studentId,
//     this.profilePicture,
//     this.fullName,
//     this.bio,
//     this.phoneNumber,
//     this.location,
//     this.createdAt,
//     this.updatedAt,
//   });

//   Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);

//   factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
//       _$ProfileApiModelFromJson(json);

//   ProfileEntity toEntity() {
//     return ProfileEntity(
//       studentId: studentId ?? id ?? '',  // fallback to id if studentId missing
//       profilePicture: profilePicture,
//       fullName: fullName,
//       bio: bio,
//       phoneNumber: phoneNumber,
//       location: location,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//     );
//   }

//   factory ProfileApiModel.fromEntity(ProfileEntity entity) {
//     return ProfileApiModel(
//       id: entity.studentId,  // usually the same
//       studentId: entity.studentId,
//       profilePicture: entity.profilePicture,
//       fullName: entity.fullName,
//       bio: entity.bio,
//       phoneNumber: entity.phoneNumber,
//       location: entity.location,
//       createdAt: entity.createdAt,
//       updatedAt: entity.updatedAt,
//     );
//   }

//   static List<ProfileEntity> toEntityList(List<ProfileApiModel> models) {
//     return models.map((model) => model.toEntity()).toList();
//   }
// }
