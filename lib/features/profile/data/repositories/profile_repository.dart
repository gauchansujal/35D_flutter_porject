import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/services/connectivity/network_info.dart';
import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
import 'package:flutter_application_1/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';
import 'package:flutter_application_1/features/profile/domain/repositores/profile_repositores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProfileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final networkInfo = ref.read(NetworkInfoProvider);
  final remoteDataSource = ref.read(ProfileRemoteDataSourceProvider);
  return ProfileRepository(
    networkInfo: networkInfo,
    profileRemoteDataSource:
        remoteDataSource, // ← correct parameter name (no space before :)
  );
});

// Repository implementation
class ProfileRepository implements IProfileRepository {
  final NetworkInfo _networkInfo;
  final IProfileRemoteDataSource _profileRemoteDataSource;

  ProfileRepository({
    required NetworkInfo networkInfo,
    required IProfileRemoteDataSource
    profileRemoteDataSource, // ← fixed type (remote, not local)
  }) : _networkInfo = networkInfo,
       _profileRemoteDataSource = profileRemoteDataSource;

  @override
  Future<Either<Failure, bool>> createProfile(ProfileEntity profile) {
    // TODO: implement createProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteProfile(String profileId) {
    // TODO: implement deleteProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProfileEntity>> getprofile(String studentId) {
    // TODO: implement getprofile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateProfile(ProfileEntity profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uplodeImage(File image) async {
    // it shoul be only insert in remot cause image take large space
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _profileRemoteDataSource.uploadProfileImage(
          image,
        );
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "not internrt connetcion"));
    }
  }

  @override
  Future<Either<Failure, String>> uplodeVideo(File video) {
    // TODO: implement uplodeVideo
    throw UnimplementedError();
  } // ← fixed variable name
}
