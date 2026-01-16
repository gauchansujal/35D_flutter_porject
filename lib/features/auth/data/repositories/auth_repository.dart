import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/services/connectivity/network_info.dart';
import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_1/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:flutter_application_1/features/auth/data/datasources/remote/auth_remote_datasources.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// UPDATED PROVIDER
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  // Read dependencies from other providers
  final authLocalDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDatasourcesProvider);
  final networkInfo = ref.read(NetworkInfoProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthRepository(
    authDatasource: authLocalDataSource,
    authRemoteDataSource: authRemoteDataSource,
    networkInfo: networkInfo,
    userSessionService: userSessionService, // Correctly passing dependency
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  // FIXED: Added the missing private field declaration
  final UserSessionService _userSessionService;

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
    required UserSessionService userSessionService,
  }) : _authDatasource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo,
       _userSessionService = userSessionService; // Correct assignment
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      if (user != null) {
        final entity = user.toEntity();
        return Right(entity); // ← Capital R: Right (not right)
      }
      return Left(
        LocalDatabaseFailure(message: 'No user logged in'),
      ); // Fixed typo: loged → logged
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final apiModel = await _authRemoteDataSource.login(email, password);
      if (apiModel != null) {
        final entity = apiModel.toEntity();
        return Right(entity);
      }
      return const Left(ApiFailure(message: "invalid credentials"));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'login failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
    // } else{
    //   try{
    //     final model = await _authDatasource.login(AutofillHints.email, AutofillHints.password);
    //     if(model!=null){
    //       final entity = model.toEntity();
    //       return Right(entity);

    //     }return const Left(
    //       LocalDatabaseFailure(message: "invalid email or password"),
    //     );
    //   }catch(e){
    //     return Left(LocalDatabaseFailure(message: e.toString()));
    //   }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // 1. Clear Hive local data
      await _authDatasource.logout();

      // 2. Clear Session Service (SharedPreferences)
      // FIX: Changed deleteUserSession() to clearSession()
      await _userSessionService.clearSession();

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingUser = await _authDatasource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "email alreday registred"),
          );
        }

        return const Right(true); // ✅ REQUIRED
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
  //   try {
  //     // Optional: Check if email already exists
  //     final emailExists = await _authDatasource.isEmailExists(
  //       entity.email ?? '',
  //     );
  //     if (emailExists) {
  //       return Left(LocalDatabaseFailure(message: 'Email already registered'));
  //     }

  //     final model = AuthHiveModel.fromEntity(entity);
  //     final result = await _authDatasource.register(model);

  //     return result
  //         ? const Right(true)
  //         : Left(LocalDatabaseFailure(message: 'Failed to register user'));
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: e.toString()));
  //   }
  // }
}
