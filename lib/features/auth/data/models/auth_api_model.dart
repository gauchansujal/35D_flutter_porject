import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? userid;
  final String fullname;
  final String email;
  // final String? phoneNumber;
  // final String username;
  final String? password;
  final String? profilepicture;
  final String? confirmPassword;

  AuthApiModel({
    this.userid,
    required this.fullname,
    required this.email,
    this.password,
    this.profilepicture,
    this.confirmPassword,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "id": userid,
      "firstname": fullname.split(' ').first,
      "lastname":
          fullname.split(' ').length > 1 ? fullname.split(' ').last : '',
      "username": fullname.split(' ').first,
      "email": email,
      "password": password,

      "confirmPassword": confirmPassword,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      userid: json['id'] as String?,
      fullname: '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim(),

      email: json['email'] as String,
      // phoneNumber: json['phoneNumber'] as String,
      // username: json['username'] as String,
      profilepicture: json['imageUrl'] as String?,
      password: '',
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userid,
      fullName: fullname,
      email: email,
      // username: username,
      // phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilepicture,
      // batchId: '',
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userid: entity.userId,
      fullname: entity.fullName ?? '',
      email: entity.email ?? '',
      // phoneNumber: entity.phoneNumber,
      //username: entity.username,
      password: entity.password,
      profilepicture: entity.profilePicture,
      confirmPassword: entity.confirmPassword,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
