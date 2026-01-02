import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dartz/dartz.dart'; // Assuming you're using dartz for Either
// Adjust path as needed

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? batchId;
  final String username;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.batchId,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    batchId,
    username,
    password,
  ];
}

abstract class UsecaseWithParams<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  const RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) async {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber, // Now included!
      // batchId: params.batchId,
      username: params.username,
      password: params.password,
      batchId: '',
    );

    return await _authRepository.register(entity);
  }
}
