// booking_repository.dart (interface)
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';

abstract interface class IBookingRepository {
  Future<Either<Failure, BookingEnitities>> createBooking(BookingEnitities booking); // ✅ was Future<Either<Failure, List<BookingEnitities>>> createBooking()
  Future<Either<Failure, Unit>> deleteBooking(String id);
  Future<Either<Failure, List<BookingEnitities>>> getAllBookings();
  Future<Either<Failure, BookingEnitities>> getBookingById(String id);
  Future<Either<Failure, Unit>> updateBooking(String id, BookingEnitities booking);
}