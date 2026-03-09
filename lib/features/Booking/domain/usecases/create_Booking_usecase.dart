// features/Booking/domain/usecases/create_booking_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/Booking/data/repositories/booking_repository.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/domain/repositores/booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createBookingUsecaseProvider = Provider((ref) {
  return CreateBookingUsecase(ref.read(BookingRepositoryProvider));
});

class CreateBookingUsecase {
  final IBookingRepository _repository;
  CreateBookingUsecase(this._repository);

  Future<Either<Failure, BookingEnitities>> call(BookingEnitities booking) {
    return _repository.createBooking(booking);
  }
}
