import 'package:flutter_application_1/features/Booking/data/repositories/booking_repository.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/domain/repositores/booking_repository.dart';
import 'package:flutter_application_1/features/Booking/presentation/providers/state/booking_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingViewModelProvider =
    NotifierProvider<BookingViewModel, BookingState>(BookingViewModel.new);

class BookingViewModel extends Notifier<BookingState> {
  late final IBookingRepository _repository;

  @override
  BookingState build() {
    _repository = ref.read(BookingRepositoryProvider);
    // Future.microtask(() => getAllBookings());
    return BookingState.initial();
  }

  Future<void> createBooking(BookingEnitities booking) async {
    state = state.copyWith(
      isCreating: true, // ← not status loading
      clearError: true,
    );

    final result = await _repository.createBooking(booking);

    result.fold(
      (failure) =>
          state = state.copyWith(
            isCreating: false, // ← reset
            status: BookingStatus.error,
            errorMessage: failure.message,
          ),
      (newBooking) =>
          state = state.copyWith(
            isCreating: false, // ← reset
            status: BookingStatus.success,
            bookings: [...state.bookings, newBooking],
            clearError: true,
          ),
    );
  }
  // getAllBookings, deleteBooking, updateBooking stay unchanged

  // ─── Get All ──────────────────────────────────────────────
  Future<void> getAllBookings() async {
    state = state.copyWith(status: BookingStatus.loading, clearError: true);

    final result = await _repository.getAllBookings();

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: BookingStatus.error,
            errorMessage: failure.message ?? 'Failed to load bookings',
          ),
      (bookings) =>
          state = state.copyWith(
            status: BookingStatus.success,
            bookings: bookings,
            clearError: true,
          ),
    );
  }

  // ─── Delete ───────────────────────────────────────────────
  Future<void> deleteBooking(String id) async {
    state = state.copyWith(
      status: BookingStatus.loading,
      clearError: true, // ← was missing clearError
    );

    final result = await _repository.deleteBooking(id);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: BookingStatus.error,
            errorMessage: failure.message,
          ),
      (_) => getAllBookings(), // ← cleaner arrow syntax
    );
  }

  // ─── Update ───────────────────────────────────────────────
  Future<void> updateBooking(String id, BookingEnitities booking) async {
    state = state.copyWith(status: BookingStatus.loading, clearError: true);

    final result = await _repository.updateBooking(id, booking);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: BookingStatus.error,
            errorMessage: failure.message,
          ),
      (_) => getAllBookings(), // ← cleaner arrow syntax
    );
  }

  // ─── Helpers ──────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(clearError: true); // ← use flag, not null
  }

  void reset() {
    state = BookingState.initial();
  }
}
