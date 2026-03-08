import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/bike_card/data/repositories/bike_repository.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/bike_card/domain/repositories/bike_repositories.dart';
import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';
import 'package:flutter_application_1/features/bike_card/presentation/view_model/bike_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBikeRepository extends Mock implements IBikeRepositrory {}

final tBike = BikeEntity(
  id: 'bike-1',
  name: 'Ninja 400',
  brand: 'Kawasaki',
  engineCC: 400,
  milage: '15km/l',
  isAvailable: true,
  price: '5000',
  imageUrl: null,
);
final tBikeList = [tBike];

// ─── Wait until state leaves initial/loading ───────────────────────────────
Future<BikeState> waitForState(ProviderContainer container) async {
  for (var i = 0; i < 20; i++) {
    final s = container.read(bikeViewModelProvider);
    if (s.status != BikeStatus.initial && s.status != BikeStatus.loading) {
      return s;
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }
  return container.read(bikeViewModelProvider);
}

void main() {
  late MockBikeRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockBikeRepository();
  });

  tearDown(() {
    container.dispose();
    reset(mockRepo);
  });

  ProviderContainer make() {
    return ProviderContainer(
      overrides: [bikeRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  // ─── 1. Initial State ────────────────────────────────────────────────────

  group('Initial state', () {
    test('loaded with bikes after build completes', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => Right(tBikeList));

      container = make();
      container.read(bikeViewModelProvider); // trigger build
      final state = await waitForState(container);

      expect(state.status, BikeStatus.loaded);
      expect(state.bikes, tBikeList);
    });

    test('is initial before async resolves', () async {
      when(() => mockRepo.getAllBikes()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return Right(tBikeList);
      });

      container = make();
      final state = container.read(bikeViewModelProvider);

      expect(
        [BikeStatus.initial, BikeStatus.loading].contains(state.status),
        isTrue,
      );
    });
  });

  // ─── 2. getAllBikes ──────────────────────────────────────────────────────

  group('getAllBikes', () {
    test('sets loaded with bikes on success', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => Right(tBikeList));

      container = make();
      container.read(bikeViewModelProvider);
      final state = await waitForState(container);

      expect(state.status, BikeStatus.loaded);
      expect(state.bikes, tBikeList);
      expect(state.errorMessage, isNull);
    });

    test('sets error on ApiFailure', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => Left(ApiFailure('', message: 'Network error')));

      container = make();
      container.read(bikeViewModelProvider);
      final state = await waitForState(container);

      expect(state.status, BikeStatus.error);
      expect(state.errorMessage, 'Network error');
    });

    test('sets error on LocalDatabaseFailure', () async {
      when(() => mockRepo.getAllBikes()).thenAnswer(
        (_) async =>
            const Left(LocalDatabaseFailure(message: 'DB read failed')),
      );

      container = make();
      container.read(bikeViewModelProvider);
      final state = await waitForState(container);

      expect(state.status, BikeStatus.error);
      expect(state.errorMessage, 'DB read failed');
    });

    test('loaded with empty list when no bikes exist', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => const Right([]));

      container = make();
      container.read(bikeViewModelProvider);
      final state = await waitForState(container);

      expect(state.status, BikeStatus.loaded);
      expect(state.bikes, isEmpty);
    });
  });

  // ─── 3. deleteBike ──────────────────────────────────────────────────────

  group('deleteBike', () {
    test('reloads bikes after successful delete', () async {
      var callCount = 0;
      when(() => mockRepo.getAllBikes()).thenAnswer((_) async {
        callCount++;
        return callCount == 1 ? Right(tBikeList) : const Right([]);
      });
      when(
        () => mockRepo.deleteBike(any()),
      ).thenAnswer((_) async => const Right(true));

      container = make();
      container.read(bikeViewModelProvider);
      await waitForState(container);

      await container.read(bikeViewModelProvider.notifier).deleteBike('bike-1');
      await waitForState(container);

      verify(() => mockRepo.deleteBike('bike-1')).called(1);
      verify(() => mockRepo.getAllBikes()).called(greaterThanOrEqualTo(2));
    });

    test('sets error state when delete fails', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => Right(tBikeList));
      when(
        () => mockRepo.deleteBike(any()),
      ).thenAnswer((_) async => Left(ApiFailure('', message: 'Delete failed')));

      container = make();
      container.read(bikeViewModelProvider);
      await waitForState(container);

      await container.read(bikeViewModelProvider.notifier).deleteBike('bike-1');

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.error);
      expect(state.errorMessage, 'Delete failed');
    });

    test('calls deleteBike with correct id', () async {
      when(
        () => mockRepo.getAllBikes(),
      ).thenAnswer((_) async => Right(tBikeList));
      when(
        () => mockRepo.deleteBike(any()),
      ).thenAnswer((_) async => const Right(true));

      container = make();
      container.read(bikeViewModelProvider);
      await waitForState(container);

      await container
          .read(bikeViewModelProvider.notifier)
          .deleteBike('bike-999');

      verify(() => mockRepo.deleteBike('bike-999')).called(1);
    });
  });

  // ─── 5. BikeEntity ──────────────────────────────────────────────────────

  group('BikeEntity', () {
    setUp(() {
      // dummy repo for entity-only tests
      container = make();
    });

    test('fullImageUrl empty when imageUrl is null', () {
      final bike = BikeEntity(
        name: 'T',
        brand: 'B',
        engineCC: 150,
        milage: '20km/l',
        isAvailable: true,
        price: '1000',
      );
      expect(bike.fullImageUrl, '');
    });

    test('fullImageUrl returns https url unchanged', () {
      final bike = BikeEntity(
        name: 'T',
        brand: 'B',
        engineCC: 150,
        milage: '20km/l',
        isAvailable: true,
        price: '1000',
        imageUrl: 'https://example.com/bike.jpg',
      );
      expect(bike.fullImageUrl, 'https://example.com/bike.jpg');
    });

    test('copyWith updates only specified fields', () {
      final updated = tBike.copyWith(name: 'Updated', isAvailable: false);
      expect(updated.name, 'Updated');
      expect(updated.isAvailable, isFalse);
      expect(updated.brand, tBike.brand);
      expect(updated.price, tBike.price);
    });

    test('two BikeEntities with same props are equal', () {
      final bike2 = BikeEntity(
        id: 'bike-1',
        name: 'Ninja 400',
        brand: 'Kawasaki',
        engineCC: 400,
        milage: '15km/l',
        isAvailable: true,
        price: '5000',
        imageUrl: null,
      );
      expect(tBike, bike2);
    });
  });
}
