import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String studentId; // Required - primary key (links to auth/student)
  final String? profilePicture; // URL to profile image
  final String? fullName; // Editable/display name
  final String? bio; // Short about/description
  final String? phoneNumber; // If managed in profile
  final String? location; // City, address, etc.
  final DateTime? createdAt; // When profile was first created
  final DateTime? updatedAt; // Last modification time

  const ProfileEntity({
    required this.studentId,
    this.profilePicture,
    this.fullName,
    this.bio,
    this.phoneNumber,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    studentId,
    profilePicture,
    fullName,
    bio,
    phoneNumber,
    location,
    createdAt,
    updatedAt,
  ];
}
