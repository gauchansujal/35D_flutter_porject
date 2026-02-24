import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';

enum BookingStatus { initial, loading, success, error }

class BookingState {
  final BookingStatus status;
  final bool isCreating; // ← ADD THIS
  final List<BookingEnitities> bookings;
  final BookingEnitities? selectedBooking;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.isCreating = false, // ← ADD THIS
    this.bookings = const [],
    this.selectedBooking,
    this.errorMessage,
  });

  factory BookingState.initial() => const BookingState(
    status: BookingStatus.initial,
    isCreating: false, // ← ADD THIS
    bookings: [],
    selectedBooking: null,
    errorMessage: null,
  );

  BookingState copyWith({
    BookingStatus? status,
    bool? isCreating, // ← ADD THIS
    List<BookingEnitities>? bookings,
    BookingEnitities? selectedBooking,
    String? errorMessage,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      isCreating: isCreating ?? this.isCreating, // ← ADD THIS
      bookings: bookings ?? this.bookings,
      selectedBooking:
          clearSelected ? null : selectedBooking ?? this.selectedBooking,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
