import 'package:flutter_application_1/features/Booking/data/models/Booking_model.dart';

abstract interface class IBookingRemoteDataSource {
  Future<BookingModel> getBookingById(String id);
  Future<List<BookingModel>> getAllBookings();
  Future<BookingModel> createBooking(BookingModel booking);
  Future<void> updateBooking(String id, BookingModel booking);
  Future<void> deleteBooking(String id);
}
// abstract interface class IBookingRemoteDataSource {
//   Future<BookingModel> getBookingById(String id);
//   Future<List<BookingModel>> getAllBookings();
//   // void → BookingModel
//   Future<BookingModel> updateBooking(String id, BookingModel booking); // void → BookingModel
//   Future<void> deleteBooking(String id);  // void is fine, no return needed
// }