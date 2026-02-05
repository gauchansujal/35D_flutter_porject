import 'dart:io';
import 'package:flutter_application_1/core/error/failures.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, AuthEntity>> getprofile(String studentId);
  Future<Either<Failure, bool>> createProfile(AuthEntity profile);
  Future<Either<Failure, bool>> updateProfile(AuthEntity profile);
  Future<Either<Failure, bool>> deleteProfile(String profileId);

  //image uplode
  Future<Either<Failure, String>> uplodeImage(File image);
  Future<Either<Failure, String>> uplodeVideo(File video);
}
