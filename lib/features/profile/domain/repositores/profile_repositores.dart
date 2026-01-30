import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getprofile(String studentId);
  Future<Either<Failure, bool>> createProfile(ProfileEntity profile);
  Future<Either<Failure, bool>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, bool>> deleteProfile(String profileId);

  //image uplode
  Future<Either<Failure, String>> uplodeImage(File image);
  Future<Either<Failure, String>> uplodeVideo(File video);
}
