import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String studentId; // Required - primary key (links to auth/student)
  final String? profilePicture; // URL to profile image
  

  const ProfileEntity({
    required this.studentId,
    this.profilePicture,
    
  });

  @override
  List<Object?> get props => [
    studentId,
    profilePicture,
  
  ];
}
