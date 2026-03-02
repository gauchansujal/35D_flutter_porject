import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/bike_card/presentation/view_model/bike_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/bike_card/data/repositories/bike_repository.dart';
import 'package:flutter_application_1/features/bike_card/domain/repositories/bike_repositories.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';

// ── Fake Repository ───────────────────────────────────────────────
class FakeBikeRepository implements IBikeRepositrory {
  bool shouldFail = false;
  List<BikeEntity> fakeList = [];

  @override
  Future<Either<Failure, List<BikeEntity>>> getAllBikes() async {
    if (shouldFail) return Left(ApiFailure(message: 'Failed to load bikes'));
    return Right(fakeList);
  }

  @override
  Future<Either<Failure, BikeEntity>> getBikeById(String id) async {
    if (shouldFail) return Left(ApiFailure(message: 'Bike not found'));
    return Right(fakeList.firstWhere((b) => b.id == id));
  }

  @override
  Future<Either<Failure, void>> addBike(BikeEntity bike) async {
    if (shouldFail) return Left(ApiFailure(message: 'Failed to add bike'));
    fakeList.add(bike);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateBike(String id, BikeEntity bike) async {
    if (shouldFail) return Left(ApiFailure(message: 'Failed to update bike'));
    fakeList = fakeList.map((b) => b.id == id ? bike : b).toList();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteBike(String id) async {
    if (shouldFail) return Left(ApiFailure(message: 'Failed to delete bike'));
    fakeList.removeWhere((b) => b.id == id);
    return const Right(null);
  }
}

// ── Fake Entity ───────────────────────────────────────────────────
final fakeBike = BikeEntity(
  id: '1',
  name: 'Test Bike',
  brand: 'Yamaha',
  price: '\$10',
  milage: '35 kmpl',
  engineCC: 150,
  imageUrl: '',
  isAvailable: true,
);

// ── Helper ────────────────────────────────────────────────────────
ProviderContainer buildContainer(FakeBikeRepository fakeRepo) {
  return ProviderContainer(
    overrides: [bikeRepositoryProvider.overrideWithValue(fakeRepo)],
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  late FakeBikeRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeBikeRepository();
    container = buildContainer(fakeRepo);
  });

  tearDown(() {
    container.dispose();
  });

  // ── Initial State ──────────────────────────────────────────────
  group('initial state', () {
    test('starts with initial state', () {
      // read before microtask runs
      final state = container.read(bikeViewModelProvider);

      expect(state.status, BikeStatus.initial);
      expect(state.bikes, isEmpty);
      expect(state.errorMessage, isNull);
    });
  });

  // ── getAllBikes ────────────────────────────────────────────────
  group('getAllBikes', () {
    test('emits loaded state with bikes', () async {
      fakeRepo.fakeList = [fakeBike];

      await container.read(bikeViewModelProvider.notifier).getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.loaded);
      expect(state.bikes.length, 1);
      expect(state.bikes, contains(fakeBike));
      expect(state.errorMessage, isNull);
    });

    test('emits error when fetch fails', () async {
      fakeRepo.shouldFail = true;

      await container.read(bikeViewModelProvider.notifier).getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.error);
      expect(state.errorMessage, 'Failed to load bikes');
    });

    test('emits empty list when no bikes', () async {
      fakeRepo.fakeList = [];

      await container.read(bikeViewModelProvider.notifier).getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.loaded);
      expect(state.bikes, isEmpty);
    });
  });

  // ── deleteBike ────────────────────────────────────────────────
  group('deleteBike', () {
    test('removes bike from repository', () async {
      fakeRepo.fakeList = [fakeBike];

      await container.read(bikeViewModelProvider.notifier).deleteBike('1');

      // getAllBikes is not awaited inside viewmodel so check repo directly
      expect(fakeRepo.fakeList, isEmpty);
    });

    test('emits error when delete fails', () async {
      fakeRepo.shouldFail = true;

      await container.read(bikeViewModelProvider.notifier).deleteBike('1');

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.error);
      expect(state.errorMessage, 'Failed to delete bike');
    });
  });

  // ── clearError ────────────────────────────────────────────────
  group('helpers', () {
    test('clearError runs without crashing', () {
      expect(
        () => container.read(bikeViewModelProvider.notifier).clearError(),
        returnsNormally,
      );
    });
  });
}
