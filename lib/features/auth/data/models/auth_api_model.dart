import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? userid;
  final String fullname;
  final String email;
  final String? phoneNumber;
  // final String username;
  final String? password;
  final String? profilepicture;

  AuthApiModel({
    this.userid,
    required this.fullname,
    required this.email,
    this.phoneNumber,
    // required this.username,
    this.password,
    this.profilepicture,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "id": userid,
      "fullname": fullname,
      "email": email,
      "phoneNumber": phoneNumber,
      // "username": username,
      "password": password,
      "profilePicture": profilepicture,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      userid: json['id'] as String?,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
     // username: json['username'] as String,
      profilepicture: json['profilePicture'] as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userid,
      fullName: fullname,
      email: email,
      // username: username,
      phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilepicture,
      // batchId: '',
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userid: entity.userId,
      fullname: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      //username: entity.username,
      password: entity.password,
      profilepicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
