import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String? fullName;
  final String? email;
  // final String? phoneNumber;
  // final String batchId;
  final String? password;
  // final String username;
  final String? profilePicture;
  final String? localProfilePicturePath;
  final String? confirmPassword;

  const AuthEntity({
    this.userId,
    this.fullName,
    this.email,
    // this.phoneNumber,
    // required this.batchId,
    // required this.username,
    this.password,
    this.profilePicture,

    this.localProfilePicturePath,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    // phoneNumber,
    // batchId,
    // username,
    password,
    profilePicture,
    localProfilePicturePath,
  ];

  AuthEntity copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    String? profilePicture,
    String? localProfilePicturePath,
    // you can add other fields later if needed
  }) {
    return AuthEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      // phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
      localProfilePicturePath:
          localProfilePicturePath ?? this.localProfilePicturePath,
      // authId is not stored as field, so ignored
    );
  }
}
