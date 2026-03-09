import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/Booking/data/datasources/booking_datasource.dart';
import 'package:flutter_application_1/features/Booking/data/models/Booking_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final BookingRemoteDatasourceProvide = Provider<IBookingRemoteDataSource>((
  ref,
) {
  return BookingRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BookingRemoteDatasource implements IBookingRemoteDataSource {
  final ApiClient _apiClient;

  BookingRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await _apiClient.post(
      '/booking',
      data: {"bike": booking.bikeId},
    );
    // unwrap { success, message, data: {...} }
    return BookingModel.fromJson(response.data['data']);
  }

  // GET /bookings
  @override
  Future<List<BookingModel>> getAllBookings() async {
    final response = await _apiClient.get('/booking');
    final List data = response.data['data'];
    return data.map((e) => BookingModel.fromJson(e)).toList();
  }

  // GET /bookings/:id
  @override
  Future<BookingModel> getBookingById(String id) async {
    final response = await _apiClient.get('/booking/$id');
    return BookingModel.fromJson(response.data['data']);
  }

  // PUT /bookings/:id
  @override
  Future<void> updateBooking(String id, BookingModel booking) async {
    await _apiClient.put(
      '/booking/$id',
      data: {
        if (booking.returnDate != null)
          "returnDate": booking.returnDate!.toIso8601String(),
      },
    );
  }

  // DELETE /bookings/:id
  @override
  Future<void> deleteBooking(String id) async {
    await _apiClient.delete('/booking/$id');
  }
}
