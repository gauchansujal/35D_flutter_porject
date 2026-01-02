import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/batch/domain/entites/batch_entity.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String batchId;
  final String? password;
  final String username;
  final BatchEntity? batch;
  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.batchId,
    required this.username,
    this.password,
    this.batch,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber,
    batchId,
    username,
    password,
    batch,
    profilePicture,
  ];
}
