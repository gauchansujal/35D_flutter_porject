import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';

enum BikeStatus { initial, loading, success, failure }

class BikeState {
  final BikeStatus status;
  final List<BikeEntity> bikes;
  final BikeEntity? selectedBike;
  final String? errorMessage;
  final String? successMessage;

  const BikeState({
    this.status = BikeStatus.initial,
    this.bikes = const [],
    this.selectedBike,
    this.errorMessage,
    this.successMessage,
  });

  BikeState copyWith({
    BikeStatus? status,
    List<BikeEntity>? bikes,
    BikeEntity? selectedBike,
    String? errorMessage,
    String? successMessage,
  }) {
    return BikeState(
      status:         status         ?? this.status,
      bikes:          bikes          ?? this.bikes,
      selectedBike:   selectedBike   ?? this.selectedBike,
      errorMessage:   errorMessage   ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isLoading => status == BikeStatus.loading;
  bool get isSuccess => status == BikeStatus.success;
  bool get isFailure => status == BikeStatus.failure;
}