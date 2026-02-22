import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';

abstract interface class IBikeRepositrory {
  Future<Either<Failure, List<BikeEntity>>> getAllBikes();
  Future<Either<Failure, BikeEntity>> getBikeById(String id);
  Future<Either<Failure, void>> addBike(BikeEntity bike);
  Future<Either<Failure, void>> updateBike(String id, BikeEntity bike);
  Future<Either<Failure, void>> deleteBike(String id);
}
