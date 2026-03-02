import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(repository: ref.read(authRepositoryProvider));
});

class UpdateProfileUsecase {
  final IAuthRepository _repository;

  UpdateProfileUsecase({required IAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, bool>> call(AuthEntity profile) {
    return _repository.updateProfile(profile);
  }
}
