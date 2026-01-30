import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
// import 'package:flutter_application_1/core/services/connectivity/network_info.dart';
import 'package:flutter_application_1/features/profile/data/datasources/local/profile_local_datasource.dart';
// import 'package:flutter_application_1/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_api_model.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_hive_model.dart';
import 'package:flutter_application_1/features/profile/domain/entites/profile_entity.dart';
import 'package:flutter_application_1/features/profile/domain/repositores/profile_repositores.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────
// Provider (only local datasource)
// ──────────────────────────────────────────────

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final localDataSource = ref.read(profileLocalDataSourceProvider);
  // final remoteDataSource = ref.read(profileRemoteDataSourceProvider);
  // final networkInfo = ref.read(NetworkInfoProvider);

  return ProfileRepository(
    localDataSource: localDataSource,
    // remoteDataSource: remoteDataSource,
    // networkInfo: networkInfo,
  );
});

// ──────────────────────────────────────────────
// Implementation class (local only for now)
// ──────────────────────────────────────────────

class ProfileRepository implements IProfileRepository {
  final ProfileLocalDataSource _localDataSource;
  // final IProfileRemoteDataSource _remoteDataSource;
  // final NetworkInfo _networkInfo;

  ProfileRepository({
    required ProfileLocalDataSource localDataSource,
    // required IProfileRemoteDataSource remoteDataSource,
    // required NetworkInfo networkInfo,
  }) : _localDataSource = localDataSource,
       // _remoteDataSource = remoteDataSource,
       // _networkInfo = networkInfo,
       super();

  @override
  Future<Either<Failure, ProfileEntity>> getprofile(String studentId) async {
    // if (await _networkInfo.isConnected) {
    //   try {
    //     final apiModel = await _remoteDataSource.getProfile(studentId);
    //     final entity = apiModel.toEntity();

    //     final hiveModel = ProfileHiveModel.fromEntity(entity);
    //     await _localDataSource.cacheProfile(hiveModel);

    //     return Right(entity);
    //   } catch (e) {
    //     return _getCachedProfile(studentId);
    //   }
    // } else {
    return _getCachedProfile(studentId);
    // }
  }

  Future<Either<Failure, ProfileEntity>> _getCachedProfile(
    String studentId,
  ) async {
    try {
      final hiveModel = await _localDataSource.getProfile(studentId);
      if (hiveModel != null) {
        return Right(hiveModel.toEntity());
      }
      return const Left(
        LocalDatabaseFailure(message: 'Profile not found in cache'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> cacheProfile(
    ProfileEntity profile,
  ) async {
    // if (await _networkInfo.isConnected) {
    //   try {
    //     final apiModel = ProfileApiModel.fromEntity(profile);
    //     final createdModel = await _remoteDataSource.createProfile(apiModel);
    //     final entity = createdModel.toEntity();

    //     final hiveModel = ProfileHiveModel.fromEntity(entity);
    //     await _localDataSource.cacheProfile(hiveModel);

    //     return Right(entity);
    //   } catch (e) {
    //     return Left(ApiFailure(message: e.toString()));
    //   }
    // } else {
    try {
      final hiveModel = ProfileHiveModel.fromEntity(profile);
      await _localDataSource.cacheProfile(hiveModel);
      return Right(profile);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
    // }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateCachedProfile(
    ProfileEntity profile,
  ) async {
    // if (await _networkInfo.isConnected) {
    //   try {
    //     final apiModel = ProfileApiModel.fromEntity(profile);
    //     final updatedModel = await _remoteDataSource.updateProfile(apiModel);
    //     final entity = updatedModel.toEntity();

    //     final hiveModel = ProfileHiveModel.fromEntity(entity);
    //     await _localDataSource.updateCachedProfile(hiveModel);

    //     return Right(entity);
    //   } catch (e) {
    //     return Left(ApiFailure(message: e.toString()));
    //   }
    // } else {
    try {
      final hiveModel = ProfileHiveModel.fromEntity(profile);
      await _localDataSource.updateCachedProfile(hiveModel);
      return Right(profile);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
    // }
  }

  @override
  Future<Either<Failure, bool>> deleteProfile(String profileId) async {
    // if (await _networkInfo.isConnected) {
    //   try {
    //     await _remoteDataSource.deleteProfile(profileId);
    //     await _localDataSource.clearProfile(profileId);
    //     return const Right(true);
    //   } catch (e) {
    //     return Left(ApiFailure(message: e.toString()));
    //   }
    // } else {
    try {
      await _localDataSource.clearProfile(profileId);
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
    // }
  }

  @override
  Future<Either<Failure, bool>> createProfile(ProfileEntity profile) {
    // TODO: implement createProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateProfile(ProfileEntity profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uplodeImage(File image) {
    // TODO: implement uplodeImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uplodeVideo(File video) {
    // TODO: implement uplodeVideo
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, String>> uplodeImage(File image) async {
  //   // For now local-only → not implemented (or you can save bytes locally)
  //   return Left(UnimplementedFailure(message: 'Image upload not implemented (local-only mode)'));
  //   // Future remote version:
  //   // if (await _networkInfo.isConnected) {
  //   //   try {
  //   //     final url = await _remoteDataSource.uploadProfileImage(image);
  //   //     return Right(url);
  //   //   } catch (e) {
  //   //     return Left(ApiFailure(message: e.toString()));
  //   //   }
  //   // } else {
  //   //   return const Left(NetworkFailure(message: 'No internet connection'));
  //   // }
  // }

  //   @override
  //   Future<Either<Failure, String>> uplodeVideo(File video) async {
  //     // For now local-only → not implemented
  //     return Left(UnimplementedFailure(message: 'Video upload not implemented (local-only mode)'));
  //     // Future remote version:
  //     // if (await _networkInfo.isConnected) {
  //     //   try {
  //     //     final url = await _remoteDataSource.uploadProfileVideo(video);
  //     //     return Right(url);
  //     //   } catch (e) {
  //     //     return Left(ApiFailure(message: e.toString()));
  //     //   }
  //     // } else {
  //     //   return const Left(NetworkFailure(message: 'No internet connection'));
  //     // }
  //   }
  // }
}
