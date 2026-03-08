import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/Booking/data/datasources/booking_datasource.dart';
import 'package:flutter_application_1/features/Booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:flutter_application_1/features/Booking/data/models/Booking_model.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/domain/repositores/booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final BookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  final bookingRemoteDatasource = ref.read(BookingRemoteDatasourceProvide);
  return BookingRepository(remoteDatasource: bookingRemoteDatasource);
});

class BookingRepository implements IBookingRepository {
  final IBookingRemoteDataSource _bookingRemoteDataSource;

  BookingRepository({required IBookingRemoteDataSource remoteDatasource})
    : _bookingRemoteDataSource = remoteDatasource;

  @override
  Future<Either<Failure, BookingEnitities>> createBooking(
    BookingEnitities booking,
  ) async {
    try {
      final model = BookingModel.fromEntity(booking);
      final result = await _bookingRemoteDataSource.createBooking(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiFailure(' ', message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBooking(String id) async {
    try {
      await _bookingRemoteDataSource.deleteBooking(id);
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEnitities>>> getAllBookings() async {
    try {
      final result = await _bookingRemoteDataSource.getAllBookings();
      return Right(BookingModel.toEntityList(result));
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEnitities>> getBookingById(String id) async {
    try {
      final result = await _bookingRemoteDataSource.getBookingById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateBooking(
    String id,
    BookingEnitities booking,
  ) async {
    try {
      final model = BookingModel.fromEntity(booking);
      await _bookingRemoteDataSource.updateBooking(id, model);
      return const Right(unit);
    } catch (e) {
      return Left(ApiFailure('', message: e.toString()));
    }
  }
}
