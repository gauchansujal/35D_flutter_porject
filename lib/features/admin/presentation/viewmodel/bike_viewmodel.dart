import 'dart:io';

import 'package:flutter_application_1/features/admin/data/repositories/bike_repository.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/create_bike_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/delete_bike_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/get_bike_by_id_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/getall_bikes_usecase.dart';
import 'package:flutter_application_1/features/admin/domain/usecases/update_bike_usecase.dart';
import 'package:flutter_application_1/features/admin/presentation/provider/state/bike_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Provider ──────────────────────────────────────────────────────────────────
final bikeViewModelProvider = StateNotifierProvider<BikeViewModel, BikeState>(
  (ref) {
    final repo = ref.read(adminBikeRepositoryProvider);
    return BikeViewModel(
      getAllBikes:   GetAllBikesUsecase(repo),
      getBikeById:  GetBikeByIdUsecase(repo),
      createBike:   CreateBikeUsecase(repo),
      updateBike:   UpdateBikeUsecase(repo),
      deleteBike:   DeleteBikeUsecase(repo),
    );
  },
);

// ── ViewModel ─────────────────────────────────────────────────────────────────
class BikeViewModel extends StateNotifier<BikeState> {
  final GetAllBikesUsecase  _getAllBikes;
  final GetBikeByIdUsecase  _getBikeById;
  final CreateBikeUsecase   _createBike;
  final UpdateBikeUsecase   _updateBike;
  final DeleteBikeUsecase   _deleteBike;

  BikeViewModel({
    required GetAllBikesUsecase  getAllBikes,
    required GetBikeByIdUsecase  getBikeById,
    required CreateBikeUsecase   createBike,
    required UpdateBikeUsecase   updateBike,
    required DeleteBikeUsecase   deleteBike,
  })  : _getAllBikes  = getAllBikes,
        _getBikeById  = getBikeById,
        _createBike   = createBike,
        _updateBike   = updateBike,
        _deleteBike   = deleteBike,
        super(const BikeState());

  // ── Fetch All ──────────────────────────────────────
  Future<void> fetchAllBikes() async {
    state = state.copyWith(status: BikeStatus.loading);
    try {
      final bikes = await _getAllBikes();
      state = state.copyWith(status: BikeStatus.success, bikes: bikes);
    } catch (e) {
      state = state.copyWith(
        status:       BikeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Fetch By ID ────────────────────────────────────
  Future<void> fetchBikeById(String id) async {
    state = state.copyWith(status: BikeStatus.loading);
    try {
      final bike = await _getBikeById(id);
      state = state.copyWith(status: BikeStatus.success, selectedBike: bike);
    } catch (e) {
      state = state.copyWith(
        status:       BikeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Create ─────────────────────────────────────────
  Future<void> createBike({
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable = true,
    File? imageFile,
  }) async {
    state = state.copyWith(status: BikeStatus.loading);
    try {
      final created = await _createBike(
        name:        name,
        brand:       brand,
        price:       price,
        engineCC:    engineCC,
        milage:      milage,
        isAvailable: isAvailable,
        imageFile:   imageFile,
      );
      state = state.copyWith(
        status:         BikeStatus.success,
        bikes:          [...state.bikes, created],
        successMessage: 'Bike created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        status:       BikeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Update ─────────────────────────────────────────
  Future<void> updateBike({
    required String id,
    required String name,
    required String brand,
    required String price,
    required int engineCC,
    required String milage,
    bool isAvailable = true,
    File? imageFile,
  }) async {
    state = state.copyWith(status: BikeStatus.loading);
    try {
      final updated = await _updateBike(
        id:          id,
        name:        name,
        brand:       brand,
        price:       price,
        engineCC:    engineCC,
        milage:      milage,
        isAvailable: isAvailable,
        imageFile:   imageFile,
      );
      final updatedList =
          state.bikes.map((b) => b.id == id ? updated : b).toList();
      state = state.copyWith(
        status:         BikeStatus.success,
        bikes:          updatedList,
        successMessage: 'Bike updated successfully',
      );
    } catch (e) {
      state = state.copyWith(
        status:       BikeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  // ── Delete ─────────────────────────────────────────
  Future<void> deleteBike(String id) async {
    state = state.copyWith(status: BikeStatus.loading);
    try {
      await _deleteBike(id);
      final updatedList = state.bikes.where((b) => b.id != id).toList();
      state = state.copyWith(
        status:         BikeStatus.success,
        bikes:          updatedList,
        successMessage: 'Bike deleted successfully',
      );
    } catch (e) {
      state = state.copyWith(
        status:       BikeStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }
}