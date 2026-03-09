// presentation/state/bike_state.dart

import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';

enum BikeStatus { initial, loading, loaded, error }

class BikeState {
  final BikeStatus status;
  final List<BikeEntity> bikes;
  final String? errorMessage;

  const BikeState({
    required this.status,
    required this.bikes,
    this.errorMessage,
  });

  // ✅ same as AuthState.initial()
  factory BikeState.initial() {
    return const BikeState(
      status: BikeStatus.initial,
      bikes: [],
      errorMessage: null,
    );
  }

  BikeState copyWith({
    BikeStatus? status,
    List<BikeEntity>? bikes,
    String? errorMessage,
  }) {
    return BikeState(
      status: status ?? this.status,
      bikes: bikes ?? this.bikes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
