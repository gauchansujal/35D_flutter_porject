import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UplodePhotoUsecaseProvider = Provider<UplodePhotoUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UplodePhotoUsecase(repository: repository);
});

class UplodePhotoUsecase implements UsecaseWithParams<String, File> {
  final IAuthRepository _repository;
  UplodePhotoUsecase({required IAuthRepository repository})
    : _repository = repository;
  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uplodeImage(params);
  }
}
