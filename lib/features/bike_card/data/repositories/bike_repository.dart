import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/bike_card/data/datasources/bike_datasource.dart';
import 'package:flutter_application_1/features/bike_card/data/datasources/remote/bike_remote_datasource.dart';
import 'package:flutter_application_1/features/bike_card/data/models/Bike_Model.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/bike_card/domain/repositories/bike_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ lowercase b
final bikeRepositoryProvider = Provider<IBikeRepositrory>((ref) {
  final bikeRemoteDatasource = ref.read(bikeRemoteDatasourceProvider);
  return BikeRepository(remoteDatasource: bikeRemoteDatasource);
});

class BikeRepository implements IBikeRepositrory {
  final IBikeRemoteDataSource _bikeRemoteDataSource;

  BikeRepository({required IBikeRemoteDataSource remoteDatasource})
    : _bikeRemoteDataSource = remoteDatasource;

  @override
  Future<Either<Failure, List<BikeEntity>>> getAllBikes() async {
    try {
      final bikes = await _bikeRemoteDataSource.getAllBikes();
      return Right(BikeModel.toEntityList(bikes));
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BikeEntity>> getBikeById(String id) async {
    try {
      final bike = await _bikeRemoteDataSource.getBikeById(id);
      return Right(bike.toEntity());
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> addBike(BikeEntity bike) async {
  //   try {
  //     await _bikeRemoteDataSource.addBike(BikeModel.fromEntity(bike));
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(ApiFailure('', message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> updateBike(String id, BikeEntity bike) async {
  //   try {
  //     await _bikeRemoteDataSource.updateBike(id, BikeModel.fromEntity(bike));
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(ApiFailure('', message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> deleteBike(String id) async {
  //   // ✅ added
  //   try {
  //     await _bikeRemoteDataSource.deleteBike(id);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(ApiFailure('', message: e.toString()));
  //   }
  // }
}
