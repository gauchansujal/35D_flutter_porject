import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/features/bike_card/data/repositories/bike_repository.dart';
import 'package:flutter_application_1/features/bike_card/domain/repositories/bike_repositories.dart';
// ← fix this line!

final bikeViewModelProvider = NotifierProvider<BikeViewModel, BikeState>(
  BikeViewModel.new, // ← better style (avoids () => )
);

class BikeViewModel extends Notifier<BikeState> {
  late final IBikeRepositrory _repository;

  @override
  BikeState build() {
    _repository = ref.read(bikeRepositoryProvider);
    // Auto-fetch when view model is created (good default behavior)
    Future.microtask(() => getAllBikes());
    return BikeState.initial();
  }

  Future<void> getAllBikes() async {
    state = state.copyWith(status: BikeStatus.loading, errorMessage: null);

    final result = await _repository.getAllBikes();

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: BikeStatus.error,
            errorMessage: failure.message ?? 'Failed to load bikes',
          ),
      (bikes) =>
          state = state.copyWith(status: BikeStatus.loaded, bikes: bikes),
    );
  }

  // Future<void> deleteBike(String id) async {
  //   state = state.copyWith(status: BikeStatus.loading);

  //   final result = await _repository.deleteBike(id);

  //   result.fold(
  //     (failure) =>
  //         state = state.copyWith(
  //           status: BikeStatus.error,
  //           errorMessage: failure.message,
  //         ),
  //     (_) {
  //       // reload list after successful delete
  //       getAllBikes();
  //     },
  //   );
  // }

  // void clearError() {
  //   state = state.copyWith(errorMessage: null);
  // }
}
