import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
import 'package:flutter_application_1/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_application_1/features/profile/domain/repositores/profile_repositores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UplodePhotoUsecaseProvider = Provider<UplodePhotoUsecase>((ref) {
  final repository = ref.read(ProfileRepositoryProvider);
  return UplodePhotoUsecase(repository: repository);
});

class UplodePhotoUsecase implements UsecaseWithParams<String, File> {
  final IProfileRepository _repository;
  UplodePhotoUsecase({required IProfileRepository repository})
    : _repository = repository;
  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uplodeImage(params);
  }
}
