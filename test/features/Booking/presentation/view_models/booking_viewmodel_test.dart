import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/Booking/data/repositories/booking_repository.dart';
import 'package:flutter_application_1/features/Booking/domain/repositores/booking_repository.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/presentation/providers/state/booking_state.dart';
import 'package:flutter_application_1/features/Booking/presentation/view_models/booking_viewmodel.dart';

// ── Fake Repository ───────────────────────────────────────────────
class FakeBookingRepository implements IBookingRepository {
  bool shouldFail = false;
  List<BookingEnitities> fakeList = [];

  @override
  Future<Either<Failure, BookingEnitities>> createBooking(
    BookingEnitities booking,
  ) async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Failed to create booking'));
    fakeList.add(booking);
    return Right(booking);
  }

  @override
  Future<Either<Failure, List<BookingEnitities>>> getAllBookings() async {
    if (shouldFail) return Left(ApiFailure(message: 'Failed to load bookings'));
    return Right(fakeList);
  }

  @override
  Future<Either<Failure, Unit>> deleteBooking(String id) async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Failed to delete booking'));
    fakeList.removeWhere((b) => b.id == id);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateBooking(
    String id,
    BookingEnitities booking,
  ) async {
    if (shouldFail)
      return Left(ApiFailure(message: 'Failed to update booking'));
    fakeList = fakeList.map((b) => b.id == id ? booking : b).toList();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, BookingEnitities>> getBookingById(String id) async {
    if (shouldFail) return Left(ApiFailure(message: 'Not found'));
    return Right(fakeList.firstWhere((b) => b.id == id));
  }
}

// ── Fake Entity ───────────────────────────────────────────────────
final fakeBooking = BookingEnitities(
  id: '1',
  bikeId: 'bike_1',
  bookingDate: DateTime(2025, 1, 1),
  returnDate: DateTime(2025, 1, 2),
);

// ── Helper ────────────────────────────────────────────────────────
ProviderContainer buildContainer(FakeBookingRepository fakeRepo) {
  return ProviderContainer(
    overrides: [BookingRepositoryProvider.overrideWithValue(fakeRepo)],
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  late FakeBookingRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeBookingRepository();
    container = buildContainer(fakeRepo);
  });

  tearDown(() {
    container.dispose();
  });

  // ── Initial State ──────────────────────────────────────────────
  group('initial state', () {
    test('starts with initial state', () {
      final state = container.read(bookingViewModelProvider);

      expect(state.status, BookingStatus.initial);
      expect(state.bookings, isEmpty);
      expect(state.isCreating, isFalse);
      expect(state.errorMessage, isNull);
    });
  });

  // ── createBooking ──────────────────────────────────────────────
  group('createBooking', () {
    test('emits success and adds booking', () async {
      await container
          .read(bookingViewModelProvider.notifier)
          .createBooking(fakeBooking);

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.success);
      expect(state.bookings, contains(fakeBooking));
      expect(state.isCreating, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('emits error when create fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(bookingViewModelProvider.notifier)
          .createBooking(fakeBooking);

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.error);
      expect(state.errorMessage, 'Failed to create booking');
      expect(state.isCreating, isFalse);
    });
  });

  // ── getAllBookings ─────────────────────────────────────────────
  group('getAllBookings', () {
    test('emits success with bookings list', () async {
      fakeRepo.fakeList = [fakeBooking];

      await container.read(bookingViewModelProvider.notifier).getAllBookings();

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.success);
      expect(state.bookings.length, 1);
    });

    test('emits error when fetch fails', () async {
      fakeRepo.shouldFail = true;

      await container.read(bookingViewModelProvider.notifier).getAllBookings();

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.error);
      expect(state.errorMessage, 'Failed to load bookings');
    });
  });

  // ── deleteBooking ─────────────────────────────────────────────
  group('deleteBooking', () {
    test('removes booking from repository', () async {
      fakeRepo.fakeList = [fakeBooking];

      await container
          .read(bookingViewModelProvider.notifier)
          .deleteBooking('1');

      // getAllBookings is not awaited in viewmodel so just check repo
      expect(fakeRepo.fakeList, isEmpty);
    });

    test('emits error when delete fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(bookingViewModelProvider.notifier)
          .deleteBooking('1');

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.error);
      expect(state.errorMessage, 'Failed to delete booking');
    });
  });

  // ── updateBooking ─────────────────────────────────────────────
  group('updateBooking', () {
    test('updates booking in repository', () async {
      fakeRepo.fakeList = [fakeBooking];

      await container
          .read(bookingViewModelProvider.notifier)
          .updateBooking('1', fakeBooking);

      // getAllBookings is not awaited in viewmodel so just check repo
      expect(fakeRepo.fakeList, contains(fakeBooking));
    });

    test('emits error when update fails', () async {
      fakeRepo.shouldFail = true;

      await container
          .read(bookingViewModelProvider.notifier)
          .updateBooking('1', fakeBooking);

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.error);
      expect(state.errorMessage, 'Failed to update booking');
    });
  });

  // ── Helpers ───────────────────────────────────────────────────
  group('helpers', () {
    test('clearError runs without crashing', () {
      expect(
        () => container.read(bookingViewModelProvider.notifier).clearError(),
        returnsNormally,
      );
    });

    test('reset returns to initial state', () async {
      fakeRepo.fakeList = [fakeBooking];
      await container.read(bookingViewModelProvider.notifier).getAllBookings();

      container.read(bookingViewModelProvider.notifier).reset();

      final state = container.read(bookingViewModelProvider);
      expect(state.status, BookingStatus.initial);
      expect(state.bookings, isEmpty);
    });
  });
}
