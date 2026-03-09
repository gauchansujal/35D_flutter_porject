import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/bike_card/data/repositories/bike_repository.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/bike_card/domain/repositories/bike_repositories.dart';
import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';
import 'package:flutter_application_1/features/bike_card/presentation/view_model/bike_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Fake Repository (no mockito needed) ──────────────
class FakeBikeRepository implements IBikeRepositrory {
  Either<Failure, List<BikeEntity>> response = Right([]);

  @override
  Future<Either<Failure, List<BikeEntity>>> getAllBikes() async => response;

  @override
  Future<Either<Failure, BikeEntity>> getBikeById(String id) async =>
      throw UnimplementedError();
}

void main() {
  late FakeBikeRepository fakeRepository;
  late ProviderContainer container;

  final fakeBikes = [
    const BikeEntity(
      id: '1',
      name: 'CBR 150',
      brand: 'Honda',
      price: '200000',
      engineCC: 150,
      milage: '45kmpl',
      isAvailable: true,
    ),
    const BikeEntity(
      id: '2',
      name: 'R15',
      brand: 'Yamaha',
      price: '250000',
      engineCC: 155,
      milage: '40kmpl',
      isAvailable: true,
    ),
  ];

  setUp(() {
    fakeRepository = FakeBikeRepository();
    container = ProviderContainer(
      overrides: [bikeRepositoryProvider.overrideWithValue(fakeRepository)],
    );
  });

  tearDown(() => container.dispose());

  group('BikeViewModel', () {
    test('1 - initial state is initial with empty bikes', () {
      fakeRepository.response = Right(fakeBikes);

      final state = container.read(bikeViewModelProvider);

      expect(state.status, BikeStatus.initial);
      expect(state.bikes, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('2 - getAllBikes → loaded with bikes on success', () async {
      fakeRepository.response = Right(fakeBikes);

      final vm = container.read(bikeViewModelProvider.notifier);
      await vm.getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.loaded);
      expect(state.bikes.length, 2);
      expect(state.bikes.first.name, 'CBR 150');
      expect(state.errorMessage, isNull);
    });

    test('3 - getAllBikes → error with message on failure', () async {
      fakeRepository.response = Left(ApiFailure('', message: 'Network error'));

      final vm = container.read(bikeViewModelProvider.notifier);
      await vm.getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.error);
      expect(state.bikes, isEmpty);
      expect(state.errorMessage, 'Network error');
    });

    test(
      '4 - getAllBikes → fallback message when failure.message is null',
      () async {
        fakeRepository.response = Left(ApiFailure('', message: ''));

        final vm = container.read(bikeViewModelProvider.notifier);
        await vm.getAllBikes();

        final state = container.read(bikeViewModelProvider);
        expect(state.status, BikeStatus.error);
        expect(state.errorMessage, 'Failed to load bikes');
      },
    );

    test('5 - getAllBikes → sets loading before result arrives', () async {
      fakeRepository.response = Right(fakeBikes);

      final vm = container.read(bikeViewModelProvider.notifier);
      final future = vm.getAllBikes();

      final loadingState = container.read(bikeViewModelProvider);
      expect(loadingState.status, BikeStatus.loading);

      await future;

      expect(container.read(bikeViewModelProvider).status, BikeStatus.loaded);
    });

    test('6 - getAllBikes → clears error on successful retry', () async {
      fakeRepository.response = Left(ApiFailure('', message: 'Server down'));

      final vm = container.read(bikeViewModelProvider.notifier);
      await vm.getAllBikes();
      expect(container.read(bikeViewModelProvider).errorMessage, 'Server down');

      fakeRepository.response = Right(fakeBikes);
      await vm.getAllBikes();

      final state = container.read(bikeViewModelProvider);
      expect(state.status, BikeStatus.loaded);
      expect(state.errorMessage, isNull);
    });

    test(
      '7 - getAllBikes → loaded with empty list when API returns no bikes',
      () async {
        fakeRepository.response = const Right([]);

        final vm = container.read(bikeViewModelProvider.notifier);
        await vm.getAllBikes();

        final state = container.read(bikeViewModelProvider);
        expect(state.status, BikeStatus.loaded);
        expect(state.bikes, isEmpty);
      },
    );
  });
}
